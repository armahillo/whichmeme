require 'rails_helper'

RSpec.describe "meme_types/show.html.erb", type: :view do
  before(:each) do
  	@meme_type = create_established_memetype
  	assign(:meme_type, @meme_type)
  	assign(:memes, @meme_type.memes)

  	render
  end

  it "displays the name of the meme at the top" do
  	expect(rendered).to match(/<h1>#{@meme_type.name}<\/h1>/)
  end

  it "shows the image, medium format" do
  	expect(rendered).to match(/src=\"#{@meme_type.template.url(:medium)}\"/)
  end

  it "shows how many instances there are" do
  	expect(rendered).to match(/#{@meme_type.instance_count} submissions/)
  end

  it "shows a table of link titles, with caption" do
  	@meme_type.memes.each do |m|
  	  expect(rendered).to match(/<tr id=\"#{m.id}\">/)
  	end
  end
end
