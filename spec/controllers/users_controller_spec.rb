require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe "GET#show" do
    let!(:user) { create(:user) }
  	it "is successful" do
  		get :show, id: user.to_param
  		expect(response).to be_successful
  	end
    it "calculates their best types" do
      allow_any_instance_of(User).to receive(:best_types).and_return([{"score" => 1, "data" => MemeType.new}])
      get :show, id: user.to_param
      expect(assigns(:best_types)).to be_present
    end
  end

  describe "GET#profile" do
    context "While signed in: " do
  	  before(:each) do
        @user = create(:user)
        sign_in :user, @user
      end
  	  it "is successful" do
        get :profile
        expect(response).to be_successful
  	  end
      it "calculates their best types" do
        allow_any_instance_of(User).to receive(:best_types).and_return([{"score" => 1, "data" => MemeType.new}])
        get :profile
        expect(assigns(:best_types)).to be_present
      end
      it "shows the data from the signed in user" do
        get :profile
        expect(assigns(:user)).to eq(@user)
      end
    end

    it "disallows viewing if not signed in" do
      get :profile
      expect(response).to redirect_to(new_user_session_path)
    end
  end

end
