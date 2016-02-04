require 'date'
require 'base64'

class SpotifyClient
  TOKEN_FILENAME = '.spotify-access-token'

  def initialize(refresh_token, client_id=ENV['SPOTIFY_CLIENT_ID'], client_secret=ENV['SPOTIFY_CLIENT_SECRET'])
    raise ArgumentError, 'You must supply a spotify refresh token!' unless refresh_token
    @refresh_token = refresh_token
    @access_token_expires_at = nil
    @access_token = nil
    @client_id = client_id
    @client_secret = client_secret
  end

  def create_playlist(songs)
    maybe_refresh_token
  end

  def get_top_tracks(spotify_id)
    maybe_refresh_token

    # spotify:artist:6rqhFgbbKwnb9MLmUQDhG6 -> 6rqhFgbbKwnb9MLmUQDhG6
    spotify_id = spotify_id.split(':').last if spotify_id.include?(':')

    tracks_uri = URI("https://api.spotify.com/v1/artists/#{spotify_id}/top-tracks")
    tracks_uri.query = URI.encode_www_form(country: 'US')
    Net::HTTP.start(tracks_uri.host, tracks_uri.port, use_ssl: true) do |http|
      req = Net::HTTP::Get.new(tracks_uri.request_uri)

      resp = http.request(req)
      raise "Request Failed: #{tracks_uri}" unless resp.code.to_i < 300
      body = JSON.parse(resp.body)
      body['tracks'].map { |song| [song['name'], song['uri']] }
    end
  end

  private

  def maybe_refresh_token
    if @access_token
      seconds_left = @access_token_expires_at - Time.now

      # only refresh if less than 10 min remains
      return if seconds_left > 10 * 60
    end

    refresh_token!
  end

  def refresh_token!
    refresh_uri = URI('https://accounts.spotify.com/api/token')

    Net::HTTP.start(refresh_uri.host, refresh_uri.port, use_ssl: true) do |http|
      req = Net::HTTP::Post.new(refresh_uri.request_uri)
      req.body = URI.encode_www_form(
        grant_type: 'refresh_token',
        refresh_token: @refresh_token,
      )
      req['Content-Type'] = 'application/x-www-form-urlencoded'
      req['Authorization'] = "Basic #{Base64.encode64("#{@client_id}:#{@client_secret}").gsub(/\n/, '')}"

      resp = http.request(req)
      raise "Request Failed: #{refresh_uri} #{resp.body}" unless resp.code.to_i < 300
      new_token = JSON.parse(resp.body)

      @access_token_expires_at = Time.now + new_token.delete('expires_in')
      @access_token = new_token['access_token']
    end
  end
end
