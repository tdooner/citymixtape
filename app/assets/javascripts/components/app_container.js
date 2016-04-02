var React = require('react');

var SessionStore = require('components/session_store');

var Router = require('react-router').Router;
var Route = require('react-router').Route;
var Link = require('react-router').Link;
var LocationSelector = require('components/location_selector');
var browserHistory = require('react-router').browserHistory;
var flux = require('fluxify');

var HomePage = require('pages/home_page');
var GenrePage = require('pages/genre_page');
var EventListPage = require('pages/event_list_page');
var PlaylistPage = require('pages/playlist_page');

var AppContainer = React.createClass({
  getDefaultProps: function() {
    return { bootstrapData: {} };
  },

  getInitialState: function() {
    return { genres: [] };
  },

  updateLocation: function(locationId, previousLocationId) {
    console.log(locationId);
    this.setState({ location: locationId });
  },

  updateGenres: function(genres, previousGenres) {
    this.setState({ genres: genres });
  },

  updatePlaylistUrl: function(playlistUrl, previousPlaylistUrl) {
    console.log(playlistUrl);
    this.setState({ playlistUrl: playlistUrl });
  },

  componentWillMount: function() {
    SessionStore.on('change:playlistUrl', this.updatePlaylistUrl);
    SessionStore.on('change:location', this.updateLocation);
    SessionStore.on('change:genres', this.updateGenres);
    SessionStore.on('change', this.navigate);
  },

  componentDidMount: function() {
    if (this.props.bootstrapData.stars) {
      flux.doAction('updateStars', this.props.bootstrapData.stars)
    }

    if (this.props.bootstrapData.genres) {
      flux.doAction('changeGenres', this.props.bootstrapData.genres)
    }

    if (this.props.bootstrapData.metroArea) {
      flux.doAction('changeLocation', this.props.bootstrapData.metroArea.id)
    }

    if (this.props.bootstrapData.playlist) {
      flux.doAction('changePlaylistUrl', this.props.bootstrapData.playlist.url)
    }
  },

  componentWillUnmount: function() {
    SessionStore.off('change:playlistUrl', this.updatePlaylistUrl);
    SessionStore.off('change:location', this.updateLocation);
    SessionStore.off('change:genres', this.updateGenres);
    SessionStore.off('change', this.navigate);
  },

  navigate: function() {
    if (this.state.playlistUrl) {
      browserHistory.push('/playlist');
    } else if (this.state.location && this.state.genres.length == 0) {
      browserHistory.push('/genre');
    } else if (this.state.location && this.state.genres.length > 0) {
      browserHistory.push('/events');
    }
  },

  render: function() {
    return (
      <Router history={browserHistory}>
        <Route path="/" component={HomePage} />
        <Route path="/genre" component={GenrePage} />
        <Route path="/events" component={EventListPage} />
        <Route path="/playlist" component={PlaylistPage} />
      </Router>
    )
  }
});

module.exports = AppContainer;
