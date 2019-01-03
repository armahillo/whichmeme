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
#  token          :string
#  expires_at     :integer
#  expires        :boolean
#  refresh_token  :string
#

class UserAuth < ActiveRecord::Base
  belongs_to :user

  def self.load_auth(auth, user_id)
    self.where(oauth_provider: auth.provider, oauth_id: auth.uid, user_id: user_id).first_or_create do |user_auth|
      user_auth.token = auth.credentials.token
      user_auth.expires = auth.credentials.expires
      user_auth.expires_at = auth.credentials.expires_at
      user_auth.refresh_token = auth.credentials.refresh_token
    end
  end
end
