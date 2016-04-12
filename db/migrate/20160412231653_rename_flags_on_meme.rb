class RenameFlagsOnMeme < ActiveRecord::Migration
  def change
  	rename_column :memes, :spellcheck, :flag
  	remove_column :memes, :language  	
  end
end
