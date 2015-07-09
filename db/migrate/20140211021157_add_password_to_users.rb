class AddPasswordToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :password_digest, :string
  	add_column :users, :salt, :float
  	User.all.each do |u|
    	u.update_attribute :salt, rand
    	u.update_attribute :password_digest, Digest::SHA1.hexdigest(u.login + u.salt.to_s)
    end
  end

  def down
  	remove_column :users, :password_digest
  	remove_column :users, :salt
  end
end
