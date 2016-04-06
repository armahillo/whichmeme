require 'rails_helper'

RSpec.describe "memes/_meme_medium.html.erb", type: :view do
  before(:each) do
  	@meme_type = create_established_memetype
    @meme = @meme_type.memes.first
   	assign(:meme, @meme)
    assign(:meme_type, @meme_type)

  	render(partial: "memes/meme_medium", object: @meme)
  end

  it "uses a medium class" do
    expect(rendered).to match(/meme medium/)
  end

  it "shows the title" do
    expect(rendered).to match(/#{@meme.title}/)
  end

  it "shows the image in large format" do
    expect(rendered).to match(/img src=\"[\/\w\_\d]+\d\/medium\//)
  end
  it "shows the caption in two different p tags" do
    first_line,second_line = *JSON.parse(@meme.meme_caption)
    expect(rendered).to match(/top text-center\">#{first_line}/)
    expect(rendered).to match(/bottom text-center\">#{second_line}/)
  end
end
