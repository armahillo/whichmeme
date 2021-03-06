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

FactoryGirl.define do
  factory :user do
    name "Some User"
    sequence(:email) { |n| "test#{n}@email.com" }
    password "password"
  end

end
