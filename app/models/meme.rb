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
  belongs_to :meme_type, counter_cache: :instance_count
  has_many :memetype_associations, class_name: Games::MemetypeAssociation

  validates_presence_of [:reddit_id, :link_id, :body]
  validates_uniqueness_of [:reddit_id, :link_id]

  scope :established, -> { joins(:meme_type).where('meme_types.instance_count > 5') }
  scope :long_tail, -> { joins(:meme_type).where('meme_types.instance_count <= 5') }
  scope :spellcheck, -> { where(spellcheck: true) }
  scope :language, -> { where(language: true) }

  def to_url
    l = self.try(:link_id).split("_")[1] rescue nil
    return nil unless l.present?
    "http://www.reddit.com/r/adviceanimals/#{l}"
  end

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
