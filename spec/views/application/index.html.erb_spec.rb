require 'rails_helper'

RSpec.describe "application/index.html.erb", type: :view do
  before(:each) do
    @meme_type1 = create_established_memetype
    @meme_type2 = create_established_memetype
    @memes = Meme.all

    @news = [create(:news, title: "News Title"), create(:news, title: "News Title"), create(:news, title: "News Title")]

    assign(:recent_news, @news)
   	assign(:header_meme, create(:meme))

  	render
  end

  it "shows three news items" do
    expect(rendered.scan(/<h4>News Title<\/h4>/).size).to eq(@news.count)
  end

end
