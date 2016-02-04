class AddTopTracksToArtist < ActiveRecord::Migration[5.0]
  def change
    change_table :artists do |t|
      t.text :top_spotify_tracks
    end
  end
end
