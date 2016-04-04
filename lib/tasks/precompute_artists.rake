namespace :precompute do
  desc 'precompute / cache artists from top metro areas'
  task artists: :environment do
    MetroAreaSearchResult.find_each do |metro_area|
      concerts = JSON.parse(metro_area.results)
      concerts.each do |concert|
        concert['performances'].each do |performance|
          puts "Caching artist #{performance['artist']['display_name']}"
          songkick_id = performance['artist']['id']
          mbids = performance['artist']['identifier'].map { |i| i['mbid'] }

          SyncArtist.perform_later(songkick_id) if mbids.any?
        end
      end
    end
  end
end
