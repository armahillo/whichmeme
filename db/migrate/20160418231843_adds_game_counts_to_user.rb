class AddsGameCountsToUser < ActiveRecord::Migration
  def up
    add_column :users, :memetype_associations_count, :integer
    add_column :users, :typememe_associations_count, :integer
    add_column :users, :memetype_associations_correct, :integer
    add_column :users, :typememe_associations_correct, :integer

    print "Resetting counters and calculating current accuracy: "
    User.all.each do |u|
    	User.reset_counters u.id, :memetype_associations, :typememe_associations

        u.memetype_associations_correct = Games::TypememeAssociation.by_user(u).correct.count
        u.typememe_associations_correct = Games::TypememeAssociation.by_user(u).correct.count
        u.save

    	print "."
    end
    puts ""
  end

  def down
  	remove_column :users, :memetype_associations_count
  	remove_column :users, :typememe_associations_count
  	remove_column :users, :memetype_associations_correct
  	remove_column :users, :typememe_associations_correct
  end
end
