class AddSimilarArtistsToArtists < ActiveRecord::Migration[5.0]
  def change
    change_table :artists do |t|
      t.text :similar_artists, null: false, default: '[]'
    end
  end
end
