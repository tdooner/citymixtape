class LocationSearchResult < ApplicationRecord

  def self.search_prefix(prefix)
    prefix = sanitize_sql_like(prefix)

    where('lower(query) like ?', "#{prefix.downcase}%")
  end

  def self.create_from_query(query)
    model = find_by(query: query) ||
      create(query: query, results: SONGKICK.location_search(query: query).results.to_json)

    JSON.parse(model.results)
  end

  private

  def self.normalize_query(query)
    query.strip.downcase
  end
end
