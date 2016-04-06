require 'rails_helper'

RSpec.describe "memes/index.html.erb", type: :view do
  before(:each) do
  	@meme_type1 = create_established_memetype
    @meme_type2 = create_established_memetype
    @memes = Meme.all
   	assign(:memes, @memes)

  	render
  end

  it "shows the memes in medium format" do
    expect(rendered.scan(/article class=\"meme medium\"/).size).to eq(@memes.count)
  end
end
