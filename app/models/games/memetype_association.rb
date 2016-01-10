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

  # Their answer
  has_one :meme

  # The actual meme
  has_one :correct_meme, class_name: "Meme", foreign_key: "correct_meme_id"

  scope :by_user, ->(user_id) { where(user_id: user_id) }
end
