require 'rails_helper'

RSpec.describe "games/memetype_associations/new.html.erb", type: :view do
  context "while signed in" do
  	before(:each) do
  	  @user = create(:user)
  	  sign_in :user, @user

  	  @memes = [create(:meme), create(:meme), create(:meme)]
  	  assign(:memes, @memes)
  	  @meme_type = @memes.first.meme_type
  	  assign(:meme_type, @meme_type)
  	  assign(:memetype_association, create(:games_memetype_association, user: @user, correct_meme_id: Meme.first.id))
  		  	  
  	  render
  	end
  	
  	it "is has radio buttons for each text id" do
  		@memes.each do |m|
  		  expect(rendered).to match(/value=\"#{m.id}\"/)
  		end
    end

    it "has 3 different texts" do
      @memes.each do |m|
        first_line = JSON.parse(m.meme_caption).first
        expect(rendered).to match(/#{first_line}/)
      end
  		
  		
  	end

  	it "stores the data necessary to rebuild the association" do
  		meme_ids = @memes.collect { |m| m.id }.join(",")
  		expect(rendered).to match(/id=\"meme_ids\" value=\"#{meme_ids}\"/)
  		expect(rendered).to match(/id=\"meme_type_id\" value=\"#{@meme_type.id}\"/)
  	end
  end
end
