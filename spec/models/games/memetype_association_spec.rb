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

end
