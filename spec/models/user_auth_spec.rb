# == Schema Information
#
# Table name: user_auths
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  oauth_provider :string
#  oauth_id       :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'rails_helper'

RSpec.describe UserAuth, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
