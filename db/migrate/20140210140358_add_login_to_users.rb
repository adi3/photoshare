class AddLoginToUsers < ActiveRecord::Migration
  def change
    add_column :users, :login, :string
    User.all.each do |u|
    	u.update_attribute :login, u.last_name.downcase
    end
  end

  def down
  	remove_column :users, :login
  end
end
