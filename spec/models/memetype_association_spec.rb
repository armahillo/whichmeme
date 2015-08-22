# == Schema Information
#
# Table name: memetype_associations
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  meme_type_id    :integer
#  meme_id         :integer
#  correct_meme_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

RSpec.describe MemetypeAssociation, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
