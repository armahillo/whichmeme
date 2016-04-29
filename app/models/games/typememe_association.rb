# == Schema Information
#
# Table name: games_typememe_associations
#
#  id                   :integer          not null, primary key
#  user_id              :integer
#  meme_type_id         :integer
#  meme_id              :integer
#  correct_meme_type_id :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class Games::TypememeAssociation < ActiveRecord::Base
  # The user
  belongs_to :user, counter_cache: :typememe_associations_count

  # Memetype
  belongs_to :meme_type

  # Their answer
  belongs_to :meme

  # The actual meme
  belongs_to :correct_meme_type, class_name: "MemeType", foreign_key: "correct_meme_type_id"

  scope :by_user, ->(user_id) { where(user_id: user_id) }
  scope :correct, -> { where('meme_type_id = correct_meme_type_id') }
  scope :incorrect, -> { where('meme_type_id <> correct_meme_type_id') }
  scope :by_meme_type, ->(meme_type_id) { where(meme_type_id: meme_type_id) }
  scope :by_meme, ->(meme_id) { where(meme_id: meme_id) }
end
