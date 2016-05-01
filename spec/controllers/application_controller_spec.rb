require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do

  describe "GET#about" do
    it "is successful" do
      get :about
      expect(response).to be_successful
    end
  end

  describe "GET#news" do
    it "is successful" do
      get :news
      expect(response).to be_successful
    end
    it "collects the news sorted by creation" do
      news = [create(:news, created_at: 10.seconds.ago), create(:news, created_at: 1.minute.ago)]
      get :news
      expect(assigns(:news)).to match_array(news)
    end
  end

  describe "GET#index" do
    it "is succesful" do
      get :index
      expect(response).to be_successful
    end
    it "shows summary data on homepage" do
      4.times { create(:news) }
      26.times { create(:user) }
      get :index
      expect(assigns(:users).count).to eq(25)
      expect(assigns(:recent_news).count).to eq(3)
    end
  end

  describe "GET#stats" do
    it "is successful" do
      get :stats
      expect(response).to be_successful
    end
  end

end
