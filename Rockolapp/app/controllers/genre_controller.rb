class GenreController < ApplicationController
	def index
		@genres = Genre.all	if is_logged?
	end

	def show
		@genre = Genre.find(params[:id]) if is_logged?
	end

	def new
		@genre = Genre.new
	end

	def create
		unless session[:admin] or session[:superuser]
			@genre = Genre.new
			@genre.errors.add(:session, "Invalid session")
			render 'new'
			return
		end
		@genre = Genre.new(genre_params)
		if @genre.save
			redirect_to @genre
		else
			render 'new'
		end
	end

	def edit
		@genre = Genre.find(params[:id]) if is_logged? 
		rescue ActiveRecord::RecordNotFound
			render template: 'errors/no_record'
	end

	def update
		@genre = Genre.find(params[:id])
		if session[:admin] or session[:superuser] and @genre.update(genre_params)
		redirect_to @genre
		else
			render 'edit'
		end	
		rescue ActiveRecord::RecordNotFound
			render 'errors/no_record'						
	end

	def destroy
		@genre = Genre.find(params[:id])
		if session[:admin] or session[:superuser] and @genre.destroy
			redirect_to 'index'
		else
			render 'errors/fatal_error'
		end
		rescue ActiveRecord::RecordNotFound
			render 'errors/no_record'		
	end

	def read_mode(mode)
		if mode == "whitelist"
			return "White-list"
		elsif mode == "blacklist"
			return "Black-list"
		elsif mode == "freeforall"
			return "Free-for-all"
		end
	end
	helper_method :read_mode

	private
	def genre_params
		params.require(:genre).permit(:name, :mode)
	end

	def is_logged?
		if session[:admin] or session[:superuser]
			return true
		else
			render template: 'errors/no_aut'
		end
	end
end
