class Genre < ActiveRecord::Base
	validates :name, uniqueness: true
	before_save :search_genre

	private
	def search_genre
		path = File.join(Rails.public_path,'Genres.txt')
		File.open(path,'r') do |f|
			f.each_line do |io|
				puts "#{self.name} =/= #{io}"
				if /\A#{self.name}\W/.match(io)
					
					return true
				end
			end
			errors.add(:name, 'El género buscado no se encuentra disponible.<br>Todos los géneros diponibles se pueden encontrar en la siguiente lista: <a href=https://docs.google.com/spreadsheets/d/1L3F3oKddQxz2v9a_eqchacv4XXqVru1AMwsbVUqqMsU/pub>Lista de géneros</a>')
			return false			
		end
	end
end

