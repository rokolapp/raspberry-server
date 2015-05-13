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
		unless is_logged? 
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
