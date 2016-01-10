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
  describe "Validations >" do
  	it "requires a reddit_id that is unique" do
  		expect(build(:meme, reddit_id: nil)).not_to be_valid
  		m = create(:meme)
  		expect(build(:meme, reddit_id: m.reddit_id)).not_to be_valid
  	end

  	it "requires a link_id that is unique" do
  		expect(build(:meme, link_id: nil)).not_to be_valid
  		m = create(:meme)
  		expect(build(:meme, link_id: m.link_id)).not_to be_valid
  	end

  	it "requires a body be present" do
  		expect(build(:meme, body: nil)).not_to be_valid
  	end
  end

  describe "Scopes >" do
  	describe "established->" do
  		it "shows all memes where there are at least 5 of that type" do
  			t = create(:meme_type)
  			t2 = create(:meme_type)
  			6.times { create(:meme, meme_type: t) }
  			create(:meme, meme_type: t2) # this one should not show up
  			expect(Meme.established.count).to eq(6)
  		end
  	end

  	describe "long_tail->" do
  		it "shows all memes where there are 5 or fewer of that type" do
  			t = create(:meme_type)
  			t2 = create(:meme_type)
  			# this one should not show up
  			6.times { create(:meme, meme_type: t) }

  			5.times { create(:meme, meme_type: t2) }
  			expect(Meme.long_tail.count).to eq(5)
  		end
  	end
  end

  describe "Methods >" do
  	describe ".to_hash" do
  		it "exists" do
  			expect(create(:meme)).to respond_to(:to_hash)
  		end
  	end
  end
end
