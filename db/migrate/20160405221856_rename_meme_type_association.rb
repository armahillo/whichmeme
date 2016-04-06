class RenameMemeTypeAssociation < ActiveRecord::Migration
  def change
   rename_table :memetype_associations, :games_memetype_associations
  end
end
