class GenreController < ApplicationController
	def new
		@genre = Genre.new
	end
end
