var React = require('react'),
    fluxify = require('fluxify');

var SessionStore = fluxify.createStore({
  id: 'sessionStore',

  initialState: {
    location: null,
    stars: []
  },

  actionCallbacks: {
    updateStars: function(updater, stars) {
      updater.set({
        stars: stars.map(function(e) {
          return e[0] + "-" + e[1]
        })
      });
    },

    changeLocation: function(updater, location) {
      updater.set({ location: location });
    },

    changeGenres: function(updater, genres) {
      updater.set({ genres: genres });
    }
  }
});

module.exports = SessionStore;
