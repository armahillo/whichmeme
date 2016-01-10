require 'rails_helper'

RSpec.describe MemeTypesController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    let!(:meme_type) { create(:meme_type) }
    it "returns http success" do
      get :show, id: meme_type
      expect(response).to have_http_status(:success)
    end
  end

end
