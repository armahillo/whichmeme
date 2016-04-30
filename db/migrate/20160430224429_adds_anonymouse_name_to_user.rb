class AddsAnonymouseNameToUser < ActiveRecord::Migration
  def change
  	add_column :users, :fake_name, :string
  	puts "Initializing fake user names: "
  	User.all.each { |u| 
  		u.update_attributes(fake_name: Faker::Name.name + ", " + Faker::Name.suffix)
  		puts "#{u.name} => #{u.fake_name}"
  	}
  end
end
