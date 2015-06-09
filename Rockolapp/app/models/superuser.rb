class Superuser < ActiveRecord::Base
	
	before_save  :val_presence, :crypt_pass
	validates :email, uniqueness: true
	Rails.application.config.filter_parameters << :password
	before_save :crypt_pass

	def self.login(parameters)
		email = parameters[:email]
		password = parameters[:password]

		if user = find_by_email(email) and BCrypt::Password.new(user.password).is_password? password
			return user
		else
			return nil
		end
	end	

	private
	def val_presence
		validates_presence_of :name, :email, :password
	end

	def crypt_pass
		self.password = BCrypt::Password.create(self.password)
	end		
end
