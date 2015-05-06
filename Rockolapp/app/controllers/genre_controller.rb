class GenreController < ApplicationController
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

	def search_genre
		f = File.open("#{Rails.public_path}'\'")
	end
end
