require 'rails_helper'

RSpec.describe Games::MemetypeAssociationsController, type: :controller do
  describe "GET#new" do
  	it "Requires users to sign in" do
  		get :new
  		expect(response).to redirect_to(new_user_session_path)
  	end

  	context "While signed in" do
      before(:each) do
      	sign_in :user, create(:user)
      	create_established_memetype
      	2.times { create(:meme) }
      end
      it "is successful" do
      	get :new
      	expect(response).to be_successful
      end
  	end
  end

  describe "POST#create" do
    before(:each) do
      request.env["HTTP_REFERER"] =  new_games_memetype_association_path
      sign_in :user, create(:user)
      @meme_type = create(:meme_type)
      @memes = [create(:meme), create(:meme), create(:meme, meme_type_id: @meme_type.id)]
    end

    it "is successful" do
      post :create, meme_type_id: @meme_type, meme_ids: @memes.collect {|m| m.id.to_i }.join(","), memetype_association: { meme_id: @memes.last.id }
      expect(response).to redirect_to new_games_memetype_association_path
    end

    it "updates their correct if they're right" do
      user = User.last
      post :create, meme_type_id: @meme_type, meme_ids: @memes.collect {|m| m.id.to_i }.join(","), memetype_association: { meme_id: @memes.last.id }
      user.reload
      expect(user.memetype_associations_correct).to eq(1)
    end

    it "updates their total counts" do
      user = User.last
      post :create, meme_type_id: @meme_type, meme_ids: @memes.collect {|m| m.id.to_i }.join(","), memetype_association: { meme_id: @memes.last.id }
      user.reload
      expect(user.memetype_associations_count).to eq(1)
    end

    it "shows a flash[:agree] if they're correct" do
      post :create, meme_type_id: @meme_type, meme_ids: @memes.collect {|m| m.id.to_i }.join(","), memetype_association: { meme_id: @memes.last.id }
      expect(flash[:agree]).to be_present
    end

    it "shows a flash[:disagree] if they're incorrect" do
      post :create, meme_type_id: @meme_type, meme_ids: @memes.collect {|m| m.id.to_i }.join(","), memetype_association: { meme_id: @memes.first.id }
      expect(flash[:disagree]).to be_present
    end
  end
end
