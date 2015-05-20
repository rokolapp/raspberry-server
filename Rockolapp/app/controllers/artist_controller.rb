class ArtistController < ApplicationController
	def index

	end
	def search_artist 
		criteria = params[:criteria]

		case criteria
		when 'name'
			@artists = Artist.where(name: params[:name], list: params[:list])
			render json: @artists
		when 'spotify_id'
			@artists = Artist.where(spotify_id: params[:spotify_id], list: params[:list])
			render json: @artists
		else
			response.status = 404
			response.header['errors'] = 'Criterio de búsqueda incorrecto'
			render nothing: true
		end
	end
	def new
		@artist = Artist.new if is_logged?
	end
	def create
		if is_logged? 
			@artist = Artist.new(artist_params)
			if @artist.save 
				render :nothing => true, :status => 200
			else
				if @artist.errors.any?
					errors = ""
	 				@artist.errors.full_messages.each do |e|
	 					errors += (e + "\n")
					end
				end 
				response.status = 418
				response.header['errors'] = errors
				render nothing: true
			end
		end
	end
	def is_logged?
		if session[:admin] or session[:superuser]
			return true
		else
			render template: 'errors/no_aut'
		end
	end
	private
	def artist_params
		params.permit(:name, :uri, :spotify_id,:list)
	end
end
