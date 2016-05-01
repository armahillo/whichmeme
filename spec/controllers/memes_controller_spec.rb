require 'rails_helper'

RSpec.describe MemesController, type: :controller do

  describe "GET#index" do
  	it "is successful" do
  		get :index
  		expect(response).to be_successful
  	end
  end

  describe "GET#show" do
  	let!(:meme) { create(:meme) }
  	it "is successful" do
      get :show, id: meme
      expect(response).to be_successful
  	end
  end

  describe "PATCH#flag" do
    before(:each) do
      @meme = create(:meme)
      sign_in :user, create(:user)
    end
    it "changes the flag status of the instance" do
      expect { 
        xhr :patch, :flag, id: @meme.to_param
        @meme.reload
      }.to change{@meme.flag}.to(true)
    end

    it "must be signed in" do
      sign_out :user
      xhr :patch, :flag, id: @meme.to_param
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
