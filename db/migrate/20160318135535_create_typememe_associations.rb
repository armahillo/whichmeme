class CreateTypememeAssociations < ActiveRecord::Migration
  def change
    create_table :games_typememe_associations do |t|
      t.integer :user_id
      t.integer :meme_type_id
      t.integer :meme_id
      t.integer :correct_meme_type_id

      t.timestamps null: false
    end
  end
end
