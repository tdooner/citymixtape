desc 'update playlists'
task update_playlists: :environment do
  Session.where.not(playlist_uri: nil).find_each do |session|
    begin
      UpdatePlaylist.perform_now(session)
    rescue => ex
      Airbrake.notify(ex)
    end
  end
end
