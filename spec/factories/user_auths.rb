# == Schema Information
#
# Table name: user_auths
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  oauth_provider :string
#  oauth_id       :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  token          :string
#  expires_at     :integer
#  expires        :boolean
#  refresh_token  :string
#

FactoryGirl.define do
  factory :user_auth do
    user_id 1
oauth_provider "MyString"
oauth_id "MyString"
  end

end
