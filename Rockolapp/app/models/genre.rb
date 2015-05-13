class Genre < ActiveRecord::Base

	before_save :search_genre, :PUTO_NEGRO_DE_MIERDA
	#enum mode: [:whitelist, :blacklist, :freeforall]

	private
	def search_genre
		path = File.join(Rails.public_path,'Genres.txt')
		File.open(path,'r') do |f|
			f.each_line do |io|
				if /\A#{self.name}\W/.match(io)
					return true
				end
			end
			errors.add(:name, 'El género buscado no se encuentra disponible.
				Todos los géneros diponibles se pueden encontrar en la siguiente lista: https://docs.google.com/spreadsheets/d/1L3F3oKddQxz2v9a_eqchacv4XXqVru1AMwsbVUqqMsU/pub')
			return false			
		end
	end

	def PUTO_NEGRO_DE_MIERDA
		unless self.mode == "whitelist" or self.mode == "blacklist" or self.mode == "freeforall"
			errors.add(:mode, "Solo puede seleccionar uno de estos métodos: White-list, Black-list o Free-for-all")
			return false
		end
	end
end

