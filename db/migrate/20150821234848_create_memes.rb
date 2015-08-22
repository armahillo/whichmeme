class CreateMemes < ActiveRecord::Migration
  def change
    create_table :memes do |t|
      t.string :reddit_id
      t.string :link_id
      t.text :body
      t.integer :meme_type_id
      t.string :meme_caption, limit: 1024
      t.string :link_title, limit: 1024
      t.string :subreddit
      t.string :subreddit_id
      t.float :created_utc
      t.string :source
      t.string :thumbnail
      t.integer :score
      t.integer :ups
      t.float :link_created_utc
      t.string :title, limit: 1024

      t.timestamps null: false
    end
  end
end
