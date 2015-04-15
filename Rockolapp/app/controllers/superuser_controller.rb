class SuperuserController < ApplicationController
	validates [:name, :email, :password], presence: true
	
	before_save :password
end
