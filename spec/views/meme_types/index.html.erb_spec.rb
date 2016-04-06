require 'rails_helper'

RSpec.describe "meme_types/index.html.erb", type: :view do
  before(:each) do
  	@established = [create_established_memetype, create_established_memetype]
  	assign(:established, @established)
  	@long_tail = [create(:meme_type), create(:meme_type)]
    assign(:long_tail, @long_tail)

  	render
  end

  it "shows links to each established type" do
    @established.each do |mt| 
  	  expect(rendered).to match(/\"\/meme_types\/#{mt.id}\"><img src=\"/)
  	end
  end

  it "displays text links to each non-established type" do
  	@long_tail.each do |lt| 
  	  expect(rendered).to match(/\"\/meme_types\/#{lt.id}\">#{lt.name}<\/a>/)
  	end
  end
end
