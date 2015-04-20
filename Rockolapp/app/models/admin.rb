require 'bcrypt'
class Admin < ActiveRecord::Base

	Rails.application.config.filter_parameters << :password

	before_save :crypt_pass, :val_presence

	def val_presence
		validates_presence_of :name, :email, :password
	end
	
	def crypt_pass
		self.password = BCrypt::Password.create(self.password)
	end		

	def self.shout
		puts "NIGGER"
	end	

	def self.login(password)
		if BCrypt::Password.new(self.password).is_pasword? password
	end	
end
