class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
    	t.string :album_type
    	t.string :name
    	t.string :uri
    	t.string :spotify_id
    	
      t.timestamps null: false
    end
  end
end
