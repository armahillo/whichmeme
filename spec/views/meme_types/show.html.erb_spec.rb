require 'rails_helper'

RSpec.describe "memes/show.html.erb", type: :view do
  before(:each) do
  	@meme_type = create_established_memetype
  	assign(:meme_type, @meme_type)
    @meme = @meme_type.memes.first
  	assign(:meme, @meme)

  	render
  end

  it "renders the large meme template" do
    expect(rendered).to match(/article class=\"meme large/)
  end

  it "has a see more link" do
    expect(rendered).to match(/See more <a/)
  end
end
