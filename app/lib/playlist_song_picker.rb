class PlaylistSongPicker
  def initialize(metro_area_id)
    @metro_area_id = metro_area_id
    @starred_songkick_ids = []
    @similar_songkick_ids = []
    @suggested_genres = []
  end

  # @param stars Arary<String, Integer> Array of objects like ["artist", 1234]
  def personalize_stars(stars)
    @starred_songkick_ids = stars.find_all { |type, _id| type == 'artist' }.map(&:last)

    @similar_songkick_ids = @starred_songkick_ids.flat_map do |i|
      Artist.where('similar_artists @> ?', i.to_s).pluck(:songkick_id)
    end.uniq
  end

  # @param stars Arary<String> Array of genres
  def personalize_genres(genres)
    @suggested_genres = SIMILAR_GENRES.values_at(*genres).flatten.to_set
  end

  def songs
    res = MetroAreaSearchResult.search(@metro_area_id)

    mbids = res.flat_map do |show|
      Array(show['performances']).flat_map do |performance|
        Array(performance.fetch('artist', {})['identifier']).map { |i| i['mbid'] }
      end
    end.compact.uniq

    @artists = mbids.in_groups_of(100, false).flat_map do |mbids_batch|
      Artist.where(musicbrainz_id: mbids_batch).map do |artist|
        next unless artist.spotify_id

        score = 0
        score += 3 if @starred_songkick_ids.include?(artist.songkick_id)
        score += 2 if (@suggested_genres & artist.genres).any?
        score += 1 if @similar_songkick_ids.include?(artist.songkick_id)

        {
          artist_spotify_id: artist.spotify_id,
          artist_songkick_id: artist.songkick_id,
          songs: artist.parsed_top_spotify_tracks,
          score: score
        }
      end
    end.compact

    playlist_songs = []

    # TODO: Normalize by popularity or something -- 86 are similar to Bieber

    # naive playlist creation algorithm:
    # 1) pick up to 3 songs from artists with score = 6
    # 2) pick up to 2 songs from artists with score 3-6
    # until 30 songs,
    # 3) pick 1 song from artists with score from 1-3
    # 4) pick 1 song from score = 0

    @artists.find_all { |a| a[:score] == 6 }.shuffle.each do |artist|
      next unless artist[:songs].present?
      playlist_songs += artist[:songs].shuffle.first(3).map(&:last)
    end

    @artists.find_all { |a| a[:score] >= 3 && a[:score] < 6 }.shuffle.each do |artist|
      next unless artist[:songs].present?
      playlist_songs += artist[:songs].shuffle.first(2).map(&:last)
    end

    @artists.find_all { |a| a[:score] > 0 && a[:score] < 3 }.shuffle.each do |artist|
      break if playlist_songs.length >= 30
      next unless artist[:songs].present?
      playlist_songs += [artist[:songs].shuffle.first.last]
    end

    @artists.find_all { |a| a[:score] == 0 }.shuffle.each do |artist|
      break if playlist_songs.length >= 30
      next unless artist[:songs].present?
      playlist_songs += [artist[:songs].shuffle.first.last]
    end

    playlist_songs
  end
end
