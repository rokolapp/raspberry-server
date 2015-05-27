require 'net/http'
class AlbumController < ApplicationController
def index

end
def search_album 
	criteria = params[:criteria]

	case criteria
	when 'name'
		@albums = Album.where("name like? ", "#{params[:name]}%")
		render json: @albums
	when 'spotify_id'
		@albums = Album.where(spotify_id: params[:spotify_id])
		render json: @albums
	else
		response.status = 404
		response.header['errors'] = 'Criterio de búsqueda incorrecto'
		render nothing: true
	end
end
def new
	@album = Album.new if is_logged?
end
def create
	if is_logged? 
		@album = Album.new(album_params)
		if  vals_redundance(valids_params) and @album.save
			render :nothing => true, :status => 200
		else
			if @album.errors.any?
				errors = ""
 				@album.errors.full_messages.each do |e|
 					errors += (e + "\n")
				end
			end 
			response.status = 404
			response.header['errors'] += "#{errors}\n"
			render nothing: true
		end
	else
		return
	end
end
def destroy
	@album = Album.find(params[:id])
	if session[:admin] or session[:superuser] and @album.destroy
		redirect_to '/album'
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
	def album_params
		params.permit(:name, :uri, :spotify_id,:list)
	end
	def valids_params 
		params.permit(:spotify_id, :list)
	end
	def vals_redundance(params)

		uri = URI.parse("https://api.spotify.com/v1/albums/#{params[:spotify_id]}")
		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE 
		res = http.get(uri.request_uri)
		json = JSON.parse(res.body)
		if val_genres(json['genres'], params[:list]) and val_artists(json['artists'], params[:list])
			return true
		else
			return false
		end

	end
	def val_genres(genres, list)
		genres.each{ |genre|
			if Genre.exists?(name: genre.capitalize,list: list)
				response.status = 404
				response.header['errors'] = "Este album pertenece al genero: \'#{genre.capitalize}\', no es necesario registrarlo.\n"
				return false
			end
		}
		return true
	end
	def val_artists(artists, list)
		artists.each{ |artist|
			if Artist.exists?(spotify_id: artist['id'],list: list)
				response.status = 404
				response.header['errors'] = "Este album pertenece al artista: \'#{artist['name'].capitalize}\', no es necesario registrarlo."
				return false
			end
		}
		return true
	end
end
