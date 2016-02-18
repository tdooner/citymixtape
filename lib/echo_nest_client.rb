class EchoNestClient
  def initialize(api_key)
    @api_key = api_key
  end

  def fetch_artist_profile(musicbrainz_id)
    base = URI('https://developer.echonest.com/api/v4/artist/profile')
    base.query = URI.encode_www_form(
      id: "musicbrainz:artist:#{musicbrainz_id}",
      api_key: @api_key,
      bucket: %w[id:spotify genre]
    )

    Rails.logger.debug("Fetching Echo Nest Artist: #{musicbrainz_id}")
    start_time = Time.now
    resp = Net::HTTP.get_response(base)
    body = JSON.parse(resp.body)

    case body['response']['status']['code']
    when 0
      # pass
    when 5
      Rails.logger.debug "Error received: #{body['response']['status']['message']}"
      return nil
    else
      raise "Error response #{body['response']['status']['code']} from EchoNest: " +
        body['response']['status']['message']
    end

    foreign_id = body['response']['artist'].fetch('foreign_ids', [])
                   .detect { |h| h['catalog'] == 'spotify' }

    {
      'spotify_id' => (foreign_id || {})['foreign_id'],
      'genres' => body['response']['artist']['genres'].map { |g| g['name'] }
    }
  rescue => ex
    Rails.logger.error "Exception while processing: #{ex.message}"
  ensure
    # poor man's token bucket:
    sleep [0, 3 - (Time.now - start_time)].max if start_time
  end
end
