class MetroAreaSearchResult < ApplicationRecord
  self.primary_key = :metro_area_id

  scope :sf, -> { find_by(metro_area_id: 26330) }

  def city_name
    JSON.parse(results).first['venue']['metro_area']['display_name']
  end

  def self.search(metro_area_id)
    res = find_by(metro_area_id: metro_area_id) || self.sync!(metro_area_id)

    # TODO: filter out "status":"cancelled"
    JSON.parse(res.results)
  end

  def self.sync!(metro_area_id)
    page = 1
    more_results = true
    results = []

    while more_results
      api_response = SONGKICK.metro_areas_events(metro_area_id, page: page)
      results += api_response.results
      page += 1
      more_results = results.length < api_response.total_entries && api_response.results.any?
    end

    # Create the mappings of songkick_id -> musicbrainz_id for all Artists
    # needed in this MetroAreaSearchResult
    results.flat_map(&:performances).map(&:artist).each do |artist|
      # TODO: Handle multiple MBIDs per artist
      mbid = artist.identifier.map { |i| i['mbid'] }.first
      next unless mbid

      Artist.where(songkick_id: artist.id).create_with(musicbrainz_id: mbid).first_or_create
    end

    find_or_initialize_by(metro_area_id: metro_area_id).tap do |record|
      record.results = results.to_json
      record.save
    end
  end
end
