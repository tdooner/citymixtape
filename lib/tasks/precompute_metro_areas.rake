namespace :precompute do
  desc 'precompute / cache top metro areas'
  task metro_areas: :environment do
    CSV.foreach(Rails.root.join('vendor', 'Top5000Population.csv')) do |row|
      city, state, _population = row

      city.strip!
      state.strip!

      query = "#{city}, #{state}"

      puts "Precomputing search for #{query}:"
      location = LocationSearchResult.create_from_query(query)
      metro_areas = location.map { |l| l['metro_area']['id'] }.uniq
      puts "  found #{metro_areas.length} metro areas"

      metro_areas.each do |metro_area_id|
        puts "  dumping metro area #{metro_area_id}"
        MetroAreaSearchResult.search(metro_area_id)
      end
    end
  end
end
