class ChangePlaylistUriToString < ActiveRecord::Migration[5.0]
  def change
    remove_column :sessions, :playlist_uri
    add_column :sessions, :playlist_uri, :string
  end
end
