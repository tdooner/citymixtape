class SyncArtist < ApplicationJob
  queue_as :default

  def perform(musicbrainz_id)
    Artist.search_for_many([musicbrainz_id])
  end
end
