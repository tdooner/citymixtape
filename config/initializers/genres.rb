GENRES = File.readlines(Rails.root.join('config/genres.txt')).map(&:strip)

# TODO: Extract this into a lib class or somewhere not an initializer
SIMILAR_GENRES = {}
Artist.where('genres is not null').find_each do |artist|
  artist.genres.combination(2).each do |left, right|
    SIMILAR_GENRES[left] ||= Hash.new(0)
    SIMILAR_GENRES[left][right] += 1

    SIMILAR_GENRES[right] ||= Hash.new(0)
    SIMILAR_GENRES[right][left] += 1
  end
end

SIMILAR_GENRES.keys.each do |key|
  max_value = SIMILAR_GENRES[key].values.max
  SIMILAR_GENRES[key] = SIMILAR_GENRES[key].find_all { |k, v| v > (max_value / 2) }.map(&:first)
end
