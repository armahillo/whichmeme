# == Schema Information
#
# Table name: meme_types
#
#  id                    :integer          not null, primary key
#  name                  :string
#  slug                  :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  template_file_name    :string
#  template_content_type :string
#  template_file_size    :integer
#  template_updated_at   :datetime
#  instance_count        :integer
#

require 'rails_helper'

RSpec.describe MemeType, type: :model do
  describe "Methods" do
    describe ".absorb!" do
      context "when absorbing another meme_type" do
        before(:each) do
          @mt1 = create(:meme_type)
          @mt2 = create(:meme_type)
          create(:meme, meme_type: @mt1)
        end

        it "reassigns all of that types memes to this one" do
          expect {
            @mt2.absorb!(@mt1.id)
          }.to change{@mt2.memes.count}.from(0).to(1)
        end

        it "deletes the other meme_type" do
          expect {
            @mt2.absorb!(@mt1.id)
          }.to change{MemeType.count}.from(2).to(1)
        end
      end
    end

    describe ".slugify" do
      it "changes the record to the slugged version of the name" do
        name = "Something, something, darkside;"
        slug = MemeType.slug_from_name(name)
        meme_type = create(:meme_type, name: name, slug: "foo")
        expect(meme_type.slug).to eq(slug)
      end
    end

    describe "::slug_from_name" do
      it "sanitizes the provided string, replacing non-alphanumerics with underscores" do
        bad_string = "Yo dawg! I <3 butts."
        expect(MemeType.slug_from_name(bad_string)).to eq("yo_dawg_i_3_butts")
      end
    end
  end
end
