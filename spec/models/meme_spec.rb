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

require 'rails_helper'

RSpec.describe Meme, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
