class CreateArtists < ActiveRecord::Migration[5.0]
  def change
    create_table :artists, id: false do |t|
      t.string :musicbrainz_id, null: false, primary_key: true
      t.string :spotify_id

      t.index [:musicbrainz_id], unique: true

      t.timestamps
    end
  end
end
