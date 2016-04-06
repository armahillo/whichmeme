# == Schema Information
#
# Table name: games_memetype_associations
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  meme_type_id    :integer
#  meme_id         :integer
#  correct_meme_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryGirl.define do
  factory :games_memetype_association, class: 'Games::MemetypeAssociation' do
    user
    meme_type
    meme
    correct_meme_id 1

    trait :correct do
    	after(:build) do |i|
    	  i.correct_meme_id = i.meme_id
    	end
    end

    trait :incorrect do
    	after(:build) do |i|
    		i.correct_meme_id = i.meme_id + 1
    	end
    end
  end

end
