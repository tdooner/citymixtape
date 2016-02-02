class SpotifyClient
  def self.token
    JSON.parse(File.read('.spotify-access-token'))
  end

  def create_playlist(songs)
  end
end
