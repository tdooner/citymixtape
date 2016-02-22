var React = require('react');
var Star = require('components/star');
var SessionStore = require('components/session_store');
var NProgress = require('nprogress');
var flux = require('fluxify');

var EventList = React.createClass({
  getInitialState: function() {
    return { loading: false, locationId: SessionStore.location, results: null, city: null, playlistUri: null };
  },

  updateLocation: function(locationId, previousLocationId) {
    this.setState({ loading: true, locationId: locationId });

    NProgress.configure({ trickleSpeed: 100 });
    NProgress.start();

    $.ajax({
      method: 'GET',
      url: '/api/locations/' + locationId + '/events',
    }).done(function(data) {
      this.setState({ loading: false, results: data.events, city: data.city });
      NProgress.done();
    }.bind(this));
  },

  componentWillMount: function() {
    SessionStore.on('change:location', this.updateLocation);

    if (this.state.loading == false && this.state.locationId) {
      this.updateLocation(this.state.locationId, null)
    }
  },

  componentWillUnmount: function() {
    SessionStore.off('change:location', this.updateLocation);
  },

  handleCreatePlaylistClick: function(e) { 
    $.ajax({
      method: 'POST',
      url: '/api/locations/' + this.state.locationId + '/playlist',
    }).done(function(data) {
      this.setState({ playlistUri: data.spotify_uri });
    }.bind(this));
  },

  handleResetLocation: function() {
    flux.doAction('changeLocation', null)
  },

  render: function() {
    if (this.state.loading) {
      return <p>Loading...</p>
    }

    if (this.state.locationId == null) {
      return <div>Please pick a location</div>;
    }

    if (this.state.playlistUri != null) {
      return <div>
        <h2>Playlist Created!</h2>
        <p><a href={this.state.playlistUri} target="_blank">Open Playlist!</a></p>
      </div>;
    }

    var renderArtist = function(artist) {
      return (
        <li className="event-list__list-item">
          <Star objectId={artist.id} objectType="artist" />
          <span>{artist.display_name}</span>
        </li>
      );
    }

    return (
      <div>
        <h2>Bands coming to{' '}
          <span className="event-list__city" onClick={this.handleResetLocation}>{this.state.city}</span>
        </h2>
        <p>
          Pick 10 bands you like. This will help us create a playlist for you.
        </p>
        <a href="#" onClick={this.handleCreatePlaylistClick}>Create Spotify Playlist</a>
        <ul className="event-list__list">
          {this.state.results.map(renderArtist)}
        </ul>
      </div>
    );
  }
});

module.exports = EventList;
