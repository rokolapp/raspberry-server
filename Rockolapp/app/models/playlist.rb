class Playlist < ActiveRecord::Base
	validates: :uri, uniqueness: {message: " : Esta cancion ya se ha pedido, por favor elija otra"}
	validates: :ip, uniqueness: {message: " : Solo puede pedir una canción a la vez, por favor espere a que se reproduzca la suya"}
end
