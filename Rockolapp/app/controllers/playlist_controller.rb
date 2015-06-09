class PlaylistController < ApplicationController

	def new

	end

	def save
		puts "\n\n LA IP ES ESTA WEY: #{request.remote_ip} \n\n"
		redirect_to '/playlist/new'
	end


end
