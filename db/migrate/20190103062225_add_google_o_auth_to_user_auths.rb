class AddGoogleOAuthToUserAuths < ActiveRecord::Migration
  def change
    add_column :user_auths, :token, :string
    add_column :user_auths, :expires_at, :integer
    add_column :user_auths, :expires, :boolean
    add_column :user_auths, :refresh_token, :string
  end
end
