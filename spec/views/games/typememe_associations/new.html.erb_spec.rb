require 'rails_helper'

RSpec.describe "games/typememe_associations/new.html.erb", type: :view do
  context "while signed in" do
  	before(:each) do
  	  @user = create(:user)
  	  sign_in :user, @user

  	  @types = [create(:meme_type), create(:meme_type), create(:meme_type)]
  	  assign(:meme_types, @types)
  	  @meme = create(:meme, meme_type: MemeType.first)
  	  assign(:meme, @meme)
  	  assign(:typememe_association, create(:games_typememe_association, user: @user, correct_meme_type_id: MemeType.first.id))
  		  	  
  	  render
  	end
  	
  	it "is has radio buttons for each type" do
  		@types.each do |mt|
  		  expect(rendered).to match(/value=\"#{mt.id}\"/)
  		end
    end

    it "has the same meme text appearing 3 times" do
  		first_line = JSON.parse(@meme.meme_caption).first
  		expect(rendered.scan(/#{first_line}/).size).to eq(3)
  	end

  	it "stores the data necessary to rebuild the association" do
  		meme_type_ids = @types.collect { |t| t.id }.join(",")
  		expect(rendered).to match(/id=\"meme_type_ids\" value=\"#{meme_type_ids}\"/)
  		expect(rendered).to match(/id=\"meme_id\" value=\"#{@meme.id}\"/)
  	end
  end
end
