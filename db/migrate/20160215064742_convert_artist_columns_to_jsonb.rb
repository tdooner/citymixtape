class ConvertArtistColumnsToJsonb < ActiveRecord::Migration[5.0]
  def change
    change_column :artists, :similar_artists, :text, default: nil
    change_column :artists, :similar_artists, :jsonb, null: false, using: 'similar_artists::jsonb'

    change_column :artists, :genres, :text, default: nil
    change_column :artists, :genres, :jsonb, null: false, using: 'similar_artists::jsonb'
  end
end
