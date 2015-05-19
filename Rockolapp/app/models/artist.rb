class Artist < ActiveRecord::Base
	validates :spotify_id, presence:true, uniqueness: {message: ": Este artista ya se ha registrado"}
	def to_param
		spotify_id
	end
end
