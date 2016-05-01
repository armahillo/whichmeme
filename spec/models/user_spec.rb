# == Schema Information
#
# Table name: users
#
#  id                            :integer          not null, primary key
#  name                          :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  email                         :string           default(""), not null
#  encrypted_password            :string           default(""), not null
#  reset_password_token          :string
#  reset_password_sent_at        :datetime
#  remember_created_at           :datetime
#  sign_in_count                 :integer          default(0), not null
#  current_sign_in_at            :datetime
#  last_sign_in_at               :datetime
#  current_sign_in_ip            :inet
#  last_sign_in_ip               :inet
#  provider                      :string
#  uid                           :string
#  memetype_associations_count   :integer
#  typememe_associations_count   :integer
#  memetype_associations_correct :integer
#  typememe_associations_correct :integer
#  avatar_url                    :string
#

require 'rails_helper'

RSpec.describe User, type: :model do
  describe "Factory >" do
  	it "has a valid factory" do
  		expect(build(:user)).to be_valid
  	end
  end
  describe "Methods >" do
	before(:each) do
		@user = create(:user)
	end

  	describe "memetype_accuracy" do
  		it "returns a float with good data" do
  			@user.memetype_associations_correct = 1
  			@user.memetype_associations_count = 2
  			expect(@user.memetype_accuracy).to eq(0.5)
  		end

  		it "doesn't divide by zero" do
            @user.memetype_associations_correct = 0
            @user.memetype_associations_count = 0
            expect(@user.memetype_accuracy).to eq(0.0)
  		end

  		it "can handle nil values" do
  			@user.memetype_associations_correct = nil
            @user.memetype_associations_count = nil
            expect(@user.memetype_accuracy).to eq(0.0)
  		end
  	end

  	describe "typememe_accuracy" do
  		it "returns a float with good data" do
  			@user.typememe_associations_correct = 1
  			@user.typememe_associations_count = 2
  			expect(@user.typememe_accuracy).to eq(0.5)
  		end

  		it "doesn't divide by zero" do
            @user.typememe_associations_correct = 0
            @user.typememe_associations_count = 0
            expect(@user.typememe_accuracy).to eq(0.0)
  		end

  		it "can handle nil values" do
  			@user.typememe_associations_correct = nil
            @user.typememe_associations_count = nil
            expect(@user.typememe_accuracy).to eq(0.0)
  		end
  	end

  	describe "best_type" do
  		it "only returns the top-scored memetype" do
  			@meme_type_1 = create(:meme_type, id: 1)
  			@meme_type_2 = create(:meme_type, id: 2)
  			allow(Games::MemetypeAssociation).to receive(:best_types_by_user).and_return({1 => 1, 2 => 1})
  			allow(Games::TypememeAssociation).to receive(:best_types_by_user).and_return({2 => 1})

  			expect(@user.best_type["data"]).to eq(@meme_type_2)
  		end
  	end

  	describe "best_types" do
  		it "responds with a hash" do
  			@meme_type_1 = create(:meme_type, id: 1)
  			@meme_type_2 = create(:meme_type, id: 2)
  			allow(Games::MemetypeAssociation).to receive(:best_types_by_user).and_return({1 => 1, 2 => 1})
  			allow(Games::TypememeAssociation).to receive(:best_types_by_user).and_return({2 => 1})
  			expect(@user.best_types).to match_array([{"score" => 2, "data" => @meme_type_2}, {"score" => 1, "data" => @meme_type_1}])
  		end
  	end

  	describe "recalculate_stats" do
  		it "fixes the counts when they get out of sync" do
  			allow(Games::MemetypeAssociation).to receive(:total_correct_by_user).and_return(10)
  			allow(Games::TypememeAssociation).to receive(:total_correct_by_user).and_return(5)
            @user.update_attributes(memetype_associations_correct: 0, typememe_associations_correct: 0)
            @user.recalculate_stats
            @user.reload
            expect(@user.memetype_associations_correct).to eq(10)
            expect(@user.typememe_associations_correct).to eq(5)
  		end
  	end
  end

  describe "Class Methods >" do
  	describe "from_omniauth" do
  	end

  	describe "new_with_session" do
  	end
  end
end
