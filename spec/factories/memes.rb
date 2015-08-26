# == Schema Information
#
# Table name: memes
#
#  id               :integer          not null, primary key
#  reddit_id        :string
#  link_id          :string
#  body             :text
#  meme_type_id     :integer
#  meme_caption     :string(1024)
#  link_title       :string(1024)
#  subreddit        :string
#  subreddit_id     :string
#  created_utc      :float
#  source           :string
#  thumbnail        :string
#  score            :integer
#  ups              :integer
#  link_created_utc :float
#  title            :string(1024)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

FactoryGirl.define do
  factory :meme do
    reddit_id "MyString"
    link_id "MyString"
    body "MyText"
    meme_type
    meme_caption "MyString"
    link_title "MyString"
    subreddit "MyString"
    subreddit_id "MyString"
    created_utc 1.0
    source "MyString"
    thumbnail "MyString"
    score 0
    ups 0
    link_created_utc 1.0
    title "MyString"
  end
end
