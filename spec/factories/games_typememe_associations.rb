# == Schema Information
#
# Table name: games_typememe_associations
#
#  id                   :integer          not null, primary key
#  user_id              :integer
#  meme_type_id         :integer
#  meme_id              :integer
#  correct_meme_type_id :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

FactoryGirl.define do
  factory :games_typememe_association, class:'Games::TypememeAssociation' do
    user
    meme_type
    meme
    correct_meme_type_id 1

    trait :correct do
    	after(:build) do |i|
    		i.correct_meme_type_id = i.meme_type_id
    	end
    end

    trait :incorrect do
    	after(:build) do |i|
    		i.correct_meme_type_id = i.meme_type_id + 1
    	end
    end
  end

end
