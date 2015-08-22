# == Schema Information
#
# Table name: meme_types
#
#  id         :integer          not null, primary key
#  name       :string
#  slug       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :meme_type do
    name "MyString"
slug "MyString"
  end

end
