class CreatePlaylists < ActiveRecord::Migration
  def change
    create_table :playlists do |t|
	    t.string "ip", null: false
	    t.string "name", null: false
    	t.string "uri", null: false
      	t.timestamps null: false
    end
  end
end