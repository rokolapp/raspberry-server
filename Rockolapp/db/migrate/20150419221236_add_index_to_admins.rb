class AddIndexToAdmins < ActiveRecord::Migration
	def change
		add_index :admins, :email, unique: true
	end
end
