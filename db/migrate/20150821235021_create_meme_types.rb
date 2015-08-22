class CreateMemeTypes < ActiveRecord::Migration
  def change
    create_table :meme_types do |t|
      t.string :name
      t.string :slug

      t.timestamps null: false
    end
  end
end
