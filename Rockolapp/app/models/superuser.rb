class Superuser < ActiveRecord::Base
	[:name, :email, :password].each do |p| 
		validates p, presence: true
	end
	
	filter_parameter_logging :password

	before_save :crypt_pass

	def crypt_pass
		self.password = BCrypt::Password.create(self.password)
	end		
end
