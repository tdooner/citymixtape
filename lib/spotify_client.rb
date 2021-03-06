require 'date'
require 'base64'

class SpotifyClient
  TOKEN_FILENAME = '.spotify-access-token'
  class PlaylistNotFound < StandardError; end

  # converts
  # "https://api.spotify.com/v1/users/citymixtape/playlists/1qtcK3OWtSAuxPqOsG5d8G/"
  # to
  # "https://play.spotify.com/user/citymixtape/playlist/1qtcK3OWtSAuxPqOsG5d8G"
  def self.convert_playlist_url(api_url)
    return nil unless api_url
    playlist_id = api_url.split('/').last

    "https://play.spotify.com/user/citymixtape/playlist/#{playlist_id}"
  end

  def initialize(refresh_token, client_id=ENV['SPOTIFY_CLIENT_ID'], client_secret=ENV['SPOTIFY_CLIENT_SECRET'])
    raise ArgumentError, 'You must supply a spotify refresh token!' unless refresh_token
    @refresh_token = refresh_token
    @access_token_expires_at = nil
    @access_token = nil
    @client_id = client_id
    @client_secret = client_secret
  end

  def create_playlist(songs, name: 'City Mixtape')
    maybe_refresh_token

    create_uri = URI("https://api.spotify.com/v1/users/#{ENV['SPOTIFY_USER']}/playlists")
    playlist_uri = nil
    Net::HTTP.start(create_uri.host, create_uri.port, use_ssl: true) do |http|
      req = Net::HTTP::Post.new(create_uri.request_uri)
      req['Authorization'] = "Bearer #{@access_token}"
      req.body = JSON.generate(
        name: name,
        public: true,
      )
      resp = http.request(req)

      handle_failure(req, resp) unless resp.code.to_i < 300

      playlist_uri = resp['Location']

      # TODO: Don't make another HTTP connection here
      replace_playlist_tracks(playlist_uri, songs)
    end

    playlist_uri
  end

  def replace_playlist_tracks(playlist_uri, songs)
    maybe_refresh_token

    playlist = get_playlist_by_uri(URI(playlist_uri))

    playlist_uri << '/' if String === playlist_uri && !playlist_uri.ends_with?('/')
    playlist_uri = URI.join(playlist_uri, 'tracks')

    Net::HTTP.start(playlist_uri.host, playlist_uri.port, use_ssl: true) do |http|
      # First clear all the songs from the playlist:
      bunch = 0
      while bunch < playlist['tracks']['total']
        req = Net::HTTP::Delete.new(playlist_uri.request_uri)
        req['Authorization'] = "Bearer #{@access_token}"
        req.body = JSON.generate(
          positions: (bunch...[(bunch + 100), playlist['tracks']['total']].min).to_a,
          snapshot_id: playlist['snapshot_id']
        )
        resp = http.request(req)
        handle_failure(req, resp) unless resp.code.to_i < 300
        bunch += 100
      end

      # Then append songs:
      songs.in_groups_of(100, false) do |song_batch|
        req = Net::HTTP::Post.new(playlist_uri.request_uri)
        req['Authorization'] = "Bearer #{@access_token}"
        req['Content-Type'] = 'application/json'
        req.body = JSON.generate(
          uris: song_batch
        )
        resp = http.request(req)
        handle_failure(req, resp) unless resp.code.to_i < 300
      end
    end

    playlist_uri
  end

  def get_playlist_by_uri(playlist_uri)
    maybe_refresh_token

    playlist_uri = URI(playlist_uri)
    Net::HTTP.start(playlist_uri.host, playlist_uri.port, use_ssl: true) do |http|
      req = Net::HTTP::Get.new(playlist_uri.request_uri)
      req['Accept'] = 'application/json'
      req['Authorization'] = "Bearer #{@access_token}"

      resp = http.request(req)
      raise PlaylistNotFound if resp.code.to_i == 404
      handle_failure(req, resp) unless resp.code.to_i < 300

      JSON.parse(resp.body)
    end
  end

  def get_top_tracks(spotify_id)
    maybe_refresh_token

    # spotify:artist:6rqhFgbbKwnb9MLmUQDhG6 -> 6rqhFgbbKwnb9MLmUQDhG6
    spotify_id = spotify_id.split(':').last if spotify_id.include?(':')

    tracks_uri = URI("https://api.spotify.com/v1/artists/#{spotify_id}/top-tracks")
    tracks_uri.query = URI.encode_www_form(country: 'US')
    Net::HTTP.start(tracks_uri.host, tracks_uri.port, use_ssl: true) do |http|
      req = Net::HTTP::Get.new(tracks_uri.request_uri)
      req['Authorization'] = "Bearer #{@access_token}"

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

  def handle_failure(req, resp)
    raise "Request Failed: #{resp.code} #{req.path}"
  end
end
