class UpdateMetroArea < ApplicationJob
  queue_as :default

  def perform(metro_area_id)
    MetroAreaSearchResult.sync!(metro_area_id)
  end
end
