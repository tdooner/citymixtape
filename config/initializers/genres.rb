GENRES = File.readlines(Rails.root.join('config/genres.txt')).map(&:strip)
