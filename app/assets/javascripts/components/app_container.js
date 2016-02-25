var React = require('react');
var SessionStore = require('components/session_store');
var Router = require('react-router').Router;
var Route = require('react-router').Route;
var Link = require('react-router').Link;
var LocationSelector = require('components/location_selector');

var HomePage = require('pages/home_page');
var GenrePage = require('pages/genre_page');
var EventListPage = require('pages/event_list_page');

var AppContainer = React.createClass({
  getDefaultProps: function() {
    return { initialSearchQuery: "" };
  },

  getInitialState: function() {
    return { location: SessionStore.location, genres: [] };
  },

  updateLocation: function(locationId, previousLocationId) {
    this.setState({ location: locationId });
  },

  updateGenres: function(genres, previousGenres) {
    this.setState({ genres: genres });
  },

  componentDidMount: function() {
    SessionStore.on('change:location', this.updateLocation);
    SessionStore.on('change:genres', this.updateGenres);
  },

  componentWillUnmount: function() {
    SessionStore.off('change:location', this.updateLocation);
    SessionStore.off('change:genres', this.updateGenres);
  },

  render: function() {
    /*
    if (!this.state.location) {
      return <HomePage />;
    } else if (this.state.genres.length == 0) {
      return <GenrePage />;
    } else {
      return <EventListPage />;
    }
    */
    return (
      <Router>
        <Route path="/" component={HomePage} />
        <Route path="/genre" component={GenrePage} />
        <Route path="/events" component={EventListPage} />
      </Router>
    )
  }
});

module.exports = AppContainer;
