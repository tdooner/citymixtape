class GenreSimilarity
  class << self
    def _genre_map
      @genre_map ||=
        begin
          {}.tap do |hash|
            Artist.where('genres is not null').find_each do |artist|
              artist.genres.combination(2).each do |left, right|
                hash[left] ||= Hash.new(0)
                hash[left][right] += 1

                hash[right] ||= Hash.new(0)
                hash[right][left] += 1
              end
            end

            hash.keys.each do |key|
              max_value = hash[key].values.max
              # find all genres that have appeared together more than the
              # average for each key
              hash[key] = hash[key].find_all { |k, v| v > (max_value / 2) }.map(&:first)
            end
          end
        end
    end

    def similar_to(*genres)
      _genre_map.values_at(*genres.flatten).flatten.compact
    end
  end
end
