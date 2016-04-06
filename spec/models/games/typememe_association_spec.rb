# == Schema Information
#
# Table name: games_typememe_associations
#
#  id                   :integer          not null, primary key
#  user_id              :integer
#  meme_type_id         :integer
#  meme_id              :integer
#  correct_meme_type_id :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

require 'rails_helper'

RSpec.describe Games::TypememeAssociation, type: :model do
  context "Scopes >" do
    describe "->by_user" do
    	it "Only shows results for a specific user" do
    		u = create(:user)
    		u2 = create(:user)
            create(:games_typememe_association, user: u)
            create(:games_typememe_association, user: u2)
            expect(Games::TypememeAssociation.by_user(u).count).to eq(1)
    	end
    end
    describe "->correct" do
    	it "only shows cases where the meme_types match" do
    		create(:games_typememe_association, :correct)
    		create(:games_typememe_association, :incorrect)
    		expect(Games::TypememeAssociation.correct.count).to eq(1)
    	end
    end
    describe "->incorrect" do
    	it "only shows cases where the meme_type does not match" do
    		create(:games_typememe_association, :correct)
    		create(:games_typememe_association, :incorrect)
    	    expect(Games::TypememeAssociation.incorrect.count).to eq(1)
    	end
    end
    describe "->by_meme_type" do
    	it "restricts results to one particular type" do
    		target = create(:games_typememe_association)
    		create(:games_typememe_association)
    		expect(Games::TypememeAssociation.by_meme_type(target.meme_type).count).to eq(1)
    	end
    end
    describe "->by_meme" do
    	it "restricts results to one particular meme" do
    		target = create(:games_typememe_association)
    		create(:games_typememe_association)
    		expect(Games::TypememeAssociation.by_meme(target.meme).count).to eq(1)
    	end
    end
  end
end
