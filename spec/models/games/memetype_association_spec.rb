# == Schema Information
#
# Table name: games_memetype_associations
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  meme_type_id    :integer
#  meme_id         :integer
#  correct_meme_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#


require 'rails_helper'

RSpec.describe Games::MemetypeAssociation, type: :model do
  context "Scopes >" do
    describe "->by_user" do
        it "Only shows results for a specific user" do
            u = create(:user)
            u2 = create(:user)
            create(:games_memetype_association, user: u)
            create(:games_memetype_association, user: u2)
            expect(Games::MemetypeAssociation.by_user(u).count).to eq(1)
        end
    end
    describe "->correct" do
        it "only shows cases where the meme_ids match" do
            create(:games_memetype_association, :correct)
            create(:games_memetype_association, :incorrect)
            expect(Games::MemetypeAssociation.correct.count).to eq(1)
        end
    end
    describe "->incorrect" do
        it "only shows cases where the meme_id does not match" do
            create(:games_memetype_association, :correct)
            create(:games_memetype_association, :incorrect)
            expect(Games::MemetypeAssociation.incorrect.count).to eq(1)
        end
    end
    describe "->by_meme_type" do
        it "restricts results to one particular type" do
            target = create(:games_memetype_association)
            create(:games_memetype_association)
            expect(Games::MemetypeAssociation.by_meme_type(target.meme_type).count).to eq(1)
        end
    end
  end


  context "Class Methods >" do
    describe ".best_types_by_user" do
        it "returns a score and MemeType ID for each item" do
          user = create(:user)
          mt1 = create(:meme_type)
          mt2 = create(:meme_type)
          2.times { create(:games_memetype_association, :correct, user: user, meme_type: mt1) }
          create(:games_memetype_association, :correct, user: user, meme_type: mt2)
          result = Games::MemetypeAssociation.best_types_by_user(user.id)
          expect(result.count).to eq(2)
          expect(result.keys.first).to eq(mt1.id)
          expect(result.values.first).to eq(2)
        end
    end

    describe ".total_correct_by_user" do
        it "returns the total number of correct responses a user has" do
          user = create(:user)
          create(:games_memetype_association, :correct, user: user)
          create(:games_memetype_association, :correct, user: user)
          expect(Games::MemetypeAssociation.total_correct_by_user(user.id)).to eq(2)
        end
    end
  end
end
