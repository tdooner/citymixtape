class SyncArtist < ApplicationJob
  queue_as :default

  def perform(songkick_ids)
    Artist.where(songkick_id: songkick_ids).each(&:sync!)
  end
end
