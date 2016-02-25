class AddPlaylistToSessions < ActiveRecord::Migration[5.0]
  def change
    change_table :sessions do |t|
      t.jsonb :playlist_songs
      t.jsonb :playlist_uri
    end
  end
end
