class AddsFlagsToMeme < ActiveRecord::Migration
  def change
  	add_column :memes, :spellcheck, :boolean
  	add_column :memes, :language, :boolean
  end
end
