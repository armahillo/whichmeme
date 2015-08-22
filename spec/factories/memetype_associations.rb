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

FactoryGirl.define do
  factory :memetype_association do
    user_id 1
meme_type_id 1
meme_id 1
correct_meme_id 1
  end

end
