class Admin < ActiveRecord::Base
	[:name, :email, :password].each do |p| 
		validates p, presence: true
	end
	
	Rails.application.config.filter_parameters << :password

	before_save :crypt_pass

	def crypt_pass
		self.password = BCrypt::Password.create(self.password)
	end		

	def self.shout
		puts "NIGGER"
	end	
end
