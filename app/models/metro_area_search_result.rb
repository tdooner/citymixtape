class MetroAreaSearchResult < ApplicationRecord
  self.primary_key = :metro_area_id

  def self.search(metro_area_id)
    unless res = find_by(metro_area_id: metro_area_id)
      page = 1
      more_results = true
      results = []

      while more_results
        api_response = SONGKICK.metro_areas_events(metro_area_id, page: page)
        results += api_response.results
        page += 1
        more_results = results.length < api_response.total_entries && api_response.results.any?
      end

      res = create(metro_area_id: metro_area_id, results: results.to_json)
    end

    # TODO: filter out "status":"cancelled"
    JSON.parse(res.results)
  end
end
