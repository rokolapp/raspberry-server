class DashboardController < ApplicationController
def dashboard
	is_logged?
end
private
	def is_logged?
	if session[:admin] or session[:superuser]
		return true
	else
		render template: 'errors/no_aut'
	end
end
end
