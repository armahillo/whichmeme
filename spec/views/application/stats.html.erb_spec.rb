require 'rails_helper'

RSpec.describe "application/stats.html.erb", type: :view do
  before(:each) do
    @meme_type1 = create_established_memetype
    @meme_type2 = create_established_memetype
    @memes = Meme.all

    assign(:meme_types, [@meme_type1, @meme_type2, create(:meme_type)])
    assign(:meme_count, MemeType.all.count)

  	render
  end

  it "labels types insignificant if they are not established" do
    expect(rendered.scan(/\"significant/).size).to eq(2)
  end

  it "it labels some established types significant" do
    expect(rendered.scan(/\"insignificant/).size).to eq(1)
  end
end
