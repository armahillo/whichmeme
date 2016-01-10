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
    sequence(:reddit_id) { |n| "abcdef#{n}" }
    sequence(:link_id) { |n| "t3_#{n}#{n}abc" }
    body "**Philosoraptor**\r\n\r\n&gt; - IF BAY WATCH WAS A SHOW IN CURRENT TIMES\r\n\r\n&gt; - WOULD IT BE CALLED BAE WATCH?\r\n\r\n"
    meme_type
    meme_caption "[\"If bay watch was a show in current times\", \"Would it be called bae watch?\"]"
    link_title "Probably how it would of been named."
    subreddit "AdviceAnimals"
    subreddit_id "t5_2s7tt"
    created_utc { DateTime.now.utc.to_i }
    source nil
    thumbnail nil
    score nil
    ups nil
    link_created_utc nil
    title nil
  end
end
