desc 'update playlists'
task update_playlists: :environment do
  Session.where.not(playlist_uri: nil).find_each do |session|
    retried = false
    begin
      UpdatePlaylist.perform_later(session)
    rescue => ex
      Airbrake.notify(ex)

      unless retried
        retried = true
        retry
      end
    end
  end
end
