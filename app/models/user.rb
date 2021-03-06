# == Schema Information
#
# Table name: users
#
#  id                            :integer          not null, primary key
#  name                          :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  email                         :string           default(""), not null
#  encrypted_password            :string           default(""), not null
#  reset_password_token          :string
#  reset_password_sent_at        :datetime
#  remember_created_at           :datetime
#  sign_in_count                 :integer          default(0), not null
#  current_sign_in_at            :datetime
#  last_sign_in_at               :datetime
#  current_sign_in_ip            :inet
#  last_sign_in_ip               :inet
#  provider                      :string
#  uid                           :string
#  memetype_associations_count   :integer
#  typememe_associations_count   :integer
#  memetype_associations_correct :integer
#  typememe_associations_correct :integer
#  avatar_url                    :string
#  fake_name                     :string
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:google_oauth2]

  has_many :memetype_associations, class_name: Games::MemetypeAssociation
  has_many :typememe_associations, class_name: Games::TypememeAssociation
  has_many :user_auths do
    def authorize(auth)
      UserAuth.load_auth(auth, proxy_association.owner.id)
    end
  end

  scope :ranked, -> { order('last_sign_in_at DESC, (memetype_associations_correct + typememe_associations_correct) DESC') }

  def memetype_accuracy
    acc = (self.memetype_associations_correct.to_f || 0.0) / (self.memetype_associations_count || 1) 
    return acc.nan? ? 0.0 : acc
  end

  def typememe_accuracy
    acc = (self.typememe_associations_correct.to_f || 0.0) / (self.typememe_associations_count || 1)
    return acc.nan? ? 0.0 : acc
  end

  def best_type
    best_types(1).try(:first)
  end

  def best_types(limit = nil)
    meme_type_scores = Games::MemetypeAssociation.best_types_by_user(self.id)
    type_meme_scores = Games::TypememeAssociation.best_types_by_user(self.id)
    ids = (meme_type_scores.keys + type_meme_scores.keys).uniq.sort

    composite = []
    meme_types = MemeType.where(id: ids)

    meme_types.each do |mt| 
      i = {}
      i["score"] = (meme_type_scores[mt.id] || 0) + (type_meme_scores[mt.id] || 0)
      i["data"] = mt
      composite << i
     end
    result = composite.sort { |a,b| a["score"] <=> b["score"] }.reverse
    if (limit) 
      result[0...limit]
    else
      return result
    end
  end

  def recalculate_stats
    User.reset_counters id, :memetype_associations, :typememe_associations

    update_attributes(memetype_associations_correct: Games::MemetypeAssociation.total_correct_by_user(self.id),
                      typememe_associations_correct: Games::TypememeAssociation.total_correct_by_user(self.id))
    
  end

  def self.from_omniauth(auth)
    user = self.find_or_create_by(email: auth.info.email) do |user|
      user.password = user.password_confirmation = Devise.friendly_token[0,20]
      user.name = auth.info.name
      user.fake_name = (Faker::Name.name + ", " + Faker::Name.suffix) unless user.fake_name.present? 
      user.avatar_url = auth.info.try(:image) rescue ""
    end
    
  	user.user_auths.authorize(auth)

    # If they haven't provided an avatar image, let's see if we can get one this time.
    user.avatar_url ||= auth.info.try(:image) rescue nil
    return user
  end

  def self.new_with_session(params, session)
  	super.tap do |user|
      user.fake_name ||= (Faker::Name.name + ", " + Faker::Name.suffix)
  	end
  end
end
