namespace :precompute do
  desc 'precompute / cache artists from top metro areas'
  task artists: :environment do
    MetroAreaSearchResult.find_each do |metro_area|
      concerts = JSON.parse(metro_area.results)
      concerts.each do |concert|
        concert['performances'].each do |performance|
          puts "Caching artist #{performance['artist']['display_name']}"
          mbid = performance['artist']['identifier'].first['mbid'] rescue nil
          SyncArtist.perform_later(mbid) if mbid
        end
      end
    end
  end
end
