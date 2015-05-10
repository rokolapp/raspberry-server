class GenreController < ApplicationController
	def index
		if is_logged?
			@genres = Genre.all	
		else
			render template: 'errors/no_aut'
		end	
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
		params.require(:genre).permit(:name)
	end

	def is_logged?
		session[:admin] or session[:superuser]
	end
end
