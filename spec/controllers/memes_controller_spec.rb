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

end
