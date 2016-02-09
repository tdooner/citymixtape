var React = require('react');
var SessionStore = require('components/session_store');

var EventList = React.createClass({
  getInitialState: function() {
    return { loading: false, locationId: null, results: null, city: null, playlistUri: null };
  },

  updateLocation: function(locationId, previousLocationId) {
    this.setState({ loading: true, locationId: locationId });

    $.ajax({
      method: 'GET',
      url: '/api/locations/' + locationId + '/events',
    }).done(function(data) {
      this.setState({ loading: false, results: data.events, city: data.city });

      // TODO: Move this to its own component?
      $("html, body").animate({
        scrollTop: $(".page1").height() - 20
      }, 200)
    }.bind(this));
  },

  componentWillMount: function() {
    SessionStore.on('change:location', this.updateLocation);
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

  render: function() {
    if (this.state.loading) {
      return <div>Loading...</div>
    }

    if (this.state.locationId == null) {
      return <div>Please pick a location</div>;
    }

    if (this.state.playlistUri != null) {
      return <a href={this.state.playlistUri}>Open Playlist!</a>;
    }

    var renderRow = function(row) {
      return (
        <tr key={row.id}>
          <td>{row.display_name}</td>
          <td>{row.venue.display_name}</td>
          <td>{row.start}</td>
          <td>{row.spotify_id}</td>
        </tr>
      );
    }

    return (
      <div>
        <h1>Bands coming to {this.state.city}</h1>
        <a href="#" onClick={this.handleCreatePlaylistClick}>Create Spotify Playlist</a>
        <table>
          <tbody>
            {this.state.results.map(renderRow)}
          </tbody>
        </table>
      </div>
    );
  }
});

module.exports = EventList;
