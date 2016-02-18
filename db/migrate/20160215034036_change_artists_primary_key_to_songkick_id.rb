class ChangeArtistsPrimaryKeyToSongkickId < ActiveRecord::Migration[5.0]
  def change
    rename_table :artists, :artists2

    create_table 'artists', id: false, primary_key: 'songkick_id' do |t|
      t.integer  'songkick_id'
      t.datetime 'created_at',                        null: false
      t.datetime 'updated_at',                        null: false
      t.string   'spotify_id'
      t.text     'top_spotify_tracks'
      t.text     'genres',             default: '[]', null: false
      t.string   'musicbrainz_id',                    null: false

      t.index ['musicbrainz_id'], name: 'index_artists_on_musicbrainz_id', unique: true, using: :btree
    end

    execute <<-COPY.strip_heredoc
      INSERT INTO artists (songkick_id, created_at, updated_at, spotify_id, top_spotify_tracks, genres, musicbrainz_id)
      SELECT songkick_id, created_at, updated_at, spotify_id, top_spotify_tracks, genres, musicbrainz_id
        FROM artists2;
    COPY

    drop_table :artists2
  end
end
