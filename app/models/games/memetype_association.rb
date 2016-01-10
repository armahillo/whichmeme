# == Schema Information
#
# Table name: memetype_associations
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  meme_type_id    :integer
#  meme_id         :integer
#  correct_meme_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Games::MemetypeAssociation < ActiveRecord::Base
  # The user
  belongs_to :user

  # Memetype
  belongs_to :meme_type

  # Their answer
  belongs_to :meme

  # The actual meme
  belongs_to :correct_meme, class_name: "Meme", foreign_key: "correct_meme_id"

  scope :by_user, ->(user_id) { where(user_id: user_id) }
  scope :correct, -> { where('meme_id = correct_meme_id') }
  scope :incorrect, -> { where('meme_id <> correct_meme_id') }
  scope :by_meme_type, ->(meme_type_id) { where(meme_type_id: meme_type_id) }

  def self.meme_types 
  	self.where()
  end
end
