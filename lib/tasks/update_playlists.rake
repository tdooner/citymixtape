desc 'update playlists'
task update_playlists: :environment do
  Session.where.not(playlist_uri: nil).find_each do |session|
    UpdatePlaylist.perform_now(
      session.metro_area_id,
      session.stars,
      session.genres,
      session.playlist_uri
    )
  end
end
