class AdminController < ApplicationController

	def shout
		redirect_to '/'
		Admin.shout
	end

end
