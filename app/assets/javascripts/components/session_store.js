var React = require('react'),
    fluxify = require('fluxify');

var SessionStore = fluxify.createStore({
  id: 'sessionStore',
  initialState: {
    location: null
  },
  actionCallbacks: {
    changeLocation: function(updater, location) {
      console.log(location);
      updater.set({ location: location });
    }
  }
});

module.exports = SessionStore;
