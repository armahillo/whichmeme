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

class UserAuth < ActiveRecord::Base
end
