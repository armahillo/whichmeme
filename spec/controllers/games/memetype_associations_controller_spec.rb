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
      	mt = create(:meme_type)
      	2.times { create(:meme) }
      	6.times { create(:meme, meme_type: mt) }
      end
      it "is successful" do
      	get :new
      	expect(response).to be_successful
      end
  	end
  end
end
