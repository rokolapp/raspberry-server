class Album < ActiveRecord::Base
validates :spotify_id, uniqueness: {scope: :list, message: " : Este album ya se ha registrado en la lista"}
before_save :val_enums

private
def val_enums
	unless self.list == "whitelist" or self.list == "blacklist"
		errors.add(:list, "Solo puede seleccionar uno de estos tipos de listas: White-list o Black-list")
		return false
	end
end
end
