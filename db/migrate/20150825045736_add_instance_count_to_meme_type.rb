class AddInstanceCountToMemeType < ActiveRecord::Migration
  def change
    add_column :meme_types, :instance_count, :integer
  end
end
