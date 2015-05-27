class TrackController < ApplicationController
def index

end
def search_track 
	criteria = params[:criteria]

	case criteria
	when 'name'
		@tracks = Track.where("name like? ", "#{params[:name]}%")
		render json: @tracks
	when 'spotify_id'
		@tracks = Track.where(spotify_id: params[:spotify_id])
		render json: @tracks
	else
		response.status = 404
		response.header['errors'] = 'Criterio de búsqueda incorrecto'
		render nothing: true
	end
end
def new
	@track = Track.new if is_logged?
end
def create
	if is_logged? 
		@track = Track.new(track_params)
		if vals_redundance(valids_params) and @track.save 
			render :nothing => true, :status => 200
		else
			if @track.errors.any?
				errors = ""
 				@track.errors.full_messages.each do |e|
 					errors += (e + "\n")
				end
			end 
			response.status = 404
			response.header['errors'] = errors
			render nothing: true
		end
	else
		return
	end
end
def destroy
	@track = Track.find(params[:id])
	if session[:admin] or session[:superuser] and @track.destroy
		redirect_to '/track'
	else
		render 'errors/fatal_error'
	end
	rescue ActiveRecord::RecordNotFound
		render 'errors/no_record'		
end	
def is_logged?
	if session[:admin] or session[:superuser]
		return true
	else
		render template: 'errors/no_aut'
	end
end
private
	def track_params
		params.permit(:name, :uri, :spotify_id,:list)
	end
	def valids_params 
		params.permit(:spotify_id, :list)
	end
	def vals_redundance(params)
		uri = URI.parse("https://api.spotify.com/v1/tracks/#{params[:spotify_id]}")
		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE 
		res = http.get(uri.request_uri)
		json = JSON.parse(res.body)
		if val_album(json['album'], params[:list]) and val_artists(json['artists'], params[:list])
			return true
		else
			return false
		end
	end
	def val_artists(artists, list)
		artists.each{ |artist|
			if Artist.exists?(spotify_id: artist['id'],list: list)
				response.status = 404
				response.header['errors'] = "Esta cancion pertenece al artista: \'#{artist['name'].capitalize}\', no es necesario registrarlo."
				return false
			end
		}
		return true
	end	
	def val_album(album, list)
		if Album.exists?(spotify_id: album['id'], list: list)
			response.status = 404
			response.header['errors'] = "Esta cancion pertenece al album: \'#{album['name'].capitalize}\', no es necesario registrarlo."
			return false
		end
		return true
	end
end
