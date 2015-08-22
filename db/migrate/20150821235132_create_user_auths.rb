class CreateUserAuths < ActiveRecord::Migration
  def change
    create_table :user_auths do |t|
      t.integer :user_id
      t.string :oauth_provider
      t.string :oauth_id

      t.timestamps null: false
    end
  end
end
