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
		if @album.save 
			render :nothing => true, :status => 200
		else
			if @album.errors.any?
				errors = ""
 				@album.errors.full_messages.each do |e|
 					errors += (e + "\n")
				end
			end 
			response.status = 418
			response.header['errors'] = errors
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
end
