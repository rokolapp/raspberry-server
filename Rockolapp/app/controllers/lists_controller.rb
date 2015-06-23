class ListsController < ApplicationController

	def admin
		is_logged?
	end

	def save
		unless is_logged?
			return
		end
		route = File.join(Rails.root, 'config', 'list-mode.xlu')
		lists = File.open(route, 'w')
		lists.truncate(0)
		lists.puts params[:list]
		redirect_to '/lists/see'
	end

	def see
		unless is_logged?
			return
		end
		route = File.join(Rails.root, 'config', 'list-mode.xlu')
		@list = File.foreach(route).first
	end

	private
	def read_mode(lista)
		if lista == "whitelist"
			return "White-list"
		elsif lista == "blacklist"
			puts "Es esto"
			return "Black-list"
		elsif lista == "freeforall"
			return "Free-for-all"
		end
	end
	def is_logged?
		if session[:admin] or session[:superuser]
			return true
		else
			render template: 'errors/no_aut'
			return nil
		end
	end
end
