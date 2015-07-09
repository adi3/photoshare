class User < ActiveRecord::Base
	has_many	:photos
	has_many	:comments
    has_many    :tags

	validates :first_name, :last_name, :login, :password, :password_confirmation, :presence => true
	validates :login, :uniqueness=>true
    validates :password, :confirmation=>true

    def password
    	@password
    end

    def password= pass 
    	@password = pass
    	self.salt = rand
    	self.password_digest = Digest::SHA1.hexdigest(@password + self.salt.to_s)
    end

    def password_valid? pass
    	if pass.nil? 
    		return false
    	end
    	return Digest::SHA1.hexdigest(pass + self.salt.to_s).eql? self.password_digest
    end

    def full_name
        "#{self.first_name} #{self.last_name}"
    end
end
