class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.string :name
      t.string :uri
      t.string :spotify_id

      t.timestamps null: false
    end
  end
end
