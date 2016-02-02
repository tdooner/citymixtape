require 'date'
require 'base64'

class SpotifyClient
  TOKEN_FILENAME = '.spotify-access-token'

  def self.token
    JSON.parse(File.read(TOKEN_FILENAME))
  end

  def maybe_refresh_token
    token = self.class.token
    seconds_left = DateTime.parse(token['expires_at']).to_time - Time.now

    # only refresh if less than 10 min remains
    return if seconds_left > 10 * 60

    refresh_token!(token['refresh_token'], ENV['SPOTIFY_CLIENT_ID'], ENV['SPOTIFY_CLIENT_SECRET'])
  end

  def refresh_token!(refresh_token, client_id, client_secret)
    refresh_uri = URI('https://accounts.spotify.com/api/token')
    Net::HTTP.start(refresh_uri.host, refresh_uri.port, use_ssl: true) do |http|
      req = Net::HTTP::Post.new(refresh_uri.request_uri)
      req.body = URI.encode_www_form(
        grant_type: 'refresh_token',
        refresh_token: refresh_token,
      )
      req['Content-Type'] = 'application/x-www-form-urlencoded'
      req['Authorization'] = "Basic #{Base64.encode64("#{client_id}:#{client_secret}").gsub(/\n/, '')}"

      resp = http.request(req)
      raise "Request Failed: #{refresh_uri} #{resp.body}" unless resp.code.to_i < 300
      new_token = JSON.parse(resp.body)
      new_token['expires_at'] = Time.now + new_token.delete('expires_in')
      new_token['refresh_token'] = refresh_token

      File.open(TOKEN_FILENAME, 'w') do |f|
        f.puts JSON.pretty_generate(new_token)
      end
    end
  end

  def create_playlist(songs)
    maybe_refresh_token
  end
end
