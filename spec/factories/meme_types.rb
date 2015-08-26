# == Schema Information
#
# Table name: meme_types
#
#  id                    :integer          not null, primary key
#  name                  :string
#  slug                  :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  template_file_name    :string
#  template_content_type :string
#  template_file_size    :integer
#  template_updated_at   :datetime
#  instance_count        :integer
#

FactoryGirl.define do
  factory :meme_type do
    sequence(:name) { |n| "Confession Bear #{n}" }
  end

end
