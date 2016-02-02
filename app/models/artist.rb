class Artist < ApplicationRecord
  self.primary_key = :musicbrainz_id

  def self.search_for_many(musicbrainz_ids)
    existing = where(musicbrainz_id: musicbrainz_ids).index_by(&:musicbrainz_id)

    (musicbrainz_ids - existing.keys).uniq.each do |id_to_search|
      spotify_id = ECHO_NEST.musicbrainz_to_spotify(id_to_search)

      existing[id_to_search] = create(musicbrainz_id: id_to_search, spotify_id: spotify_id).spotify_id
    end

    existing
  end
end
