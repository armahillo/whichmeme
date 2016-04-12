class AddsFlaggedByIdToMeme < ActiveRecord::Migration
  def change
  	add_column :memes, :flagged_by_id, :integer
  end
end
