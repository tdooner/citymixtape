const fluxify = require('fluxify');

const SessionStore = fluxify.createStore({
  id: 'sessionStore',

  initialState: {
    location: (window.bootstrap.metroArea || {}).id,
    stars: (window.bootstrap.stars || []),
    playlistUrl: (window.bootstrap.playlist || {}).url,
    genres: window.bootstrap.genres,
  },

  actionCallbacks: {
    updateStars(updater, stars) {
      updater.set({
        stars: stars.map(function(e) {
          return e[0] + '-' + e[1];
        })
      });
    },

    changeLocation(updater, location) {
      updater.set({ location: location });
    },

    changeGenres(updater, genres) {
      updater.set({ genres: genres });
    },

    changePlaylistUrl(updater, url) {
      updater.set({ playlistUrl: url });
    },
  }
});

module.exports = SessionStore;
