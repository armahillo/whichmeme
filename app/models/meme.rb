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

class Meme < ActiveRecord::Base
  belongs_to :meme_type

  validates_presence_of [:reddit_id, :link_id, :body]
  validates_uniqueness_of [:reddit_id, :link_id]

  def to_hash
  	output = {}
  	[:id, :reddit_id, :link_id, :body, :meme_caption, :link_title, :subreddit, :subreddit_id, :created_utc, :source,
     :thumbnail, :score, :ups, :permalink, :link_created_utc, :title].each do |ivar|
      output[ivar] = self.send(ivar)
    end
    output[:meme_type_id] = self.type.id
    output[:meme_type] = self.type.name
    return output
  end

  def update_score data = nil
    data ||= retrieve_data
    @ups = data['ups']
    @score = data['score']
  end

  def update_details data = nil
    data ||= retrieve_data
    @thumbnail = data['thumbnail']
    @permalink = data['permalink']
    @link_created_utc = data['created_utc']
    @title = data['title']
  end
end
