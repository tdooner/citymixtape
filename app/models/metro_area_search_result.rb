class MetroAreaSearchResult < ApplicationRecord
  self.primary_key = :metro_area_id

  def self.search(metro_area_id)
    # TODO: Handle more than 50 events
    res = find_by(metro_area_id: metro_area_id) ||
      create(metro_area_id: metro_area_id, results: SONGKICK.metro_areas_events(metro_area_id).results.to_json)

    JSON.parse(res.results)
  end
end
