class SetDefaultsforArtistColumns < ActiveRecord::Migration[5.0]
  def change
    execute "ALTER TABLE artists ALTER COLUMN similar_artists SET DEFAULT '[]'::jsonb"
    execute "ALTER TABLE artists ALTER COLUMN genres SET DEFAULT '[]'::jsonb"
  end
end
