desc 'bootstrap songkick ids'
task 'bootstrap_songkick_ids' => :environment do
  MetroAreaSearchResult.find_each do |metro_area|
    puts metro_area.metro_area_id
    concerts = JSON.parse(metro_area.results)
    concerts.each do |concert|
      concert['performances'].each do |performance|
        songkick_id = performance['artist']['id']
        mbids = performance['artist']['identifier'].map { |i| i['mbid'] }

        next unless mbids.present?

        Artist.where(musicbrainz_id: mbids).update_all(songkick_id: songkick_id)
      end
    end
  end
end
