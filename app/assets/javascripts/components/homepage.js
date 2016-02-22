var React = require('react');
var LocationSelector = require('components/location_selector');
var GenreSelector = require('components/genre_selector');
var EventList = require('components/event_list');
var SessionStore = require('components/session_store');

var Homepage = React.createClass({
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
    var renderSection = function(section) {
      // TODO: use react-router instead
      var page1 = (
        <div className="app-page app-page1 container">
          <div className="row">
            <div className="col-xs-12">
              <h1>City Mixtape</h1>
            </div>
          </div>

          <div className="row">
            <div className="col-xs-12">
              <p>Where do you live?</p>
              <LocationSelector initialSearchQuery={this.props.initialSearchQuery} />
            </div>
          </div>
        </div>
      );

      var page2 = (
        <div className="app-page app-page2 container">
          <div className="row">
            <div className="col-xs-12">
              <h1>Favorite Genre?</h1>
              <p>This will improve song recommendations.</p>

              <GenreSelector />
            </div>
          </div>
        </div>
      )

      var page3 = (
        <div className="app-page app-page3 container">
          <div className="row">
            <div className="col-xs-12">
              <EventList />
            </div>
          </div>
        </div>
      );


      switch (section) {
        case 'location_selector':
          return page1;
          break;
        case 'genre_selector':
          return page2;
          break;
        case 'event_list':
          return page3;
          break;
      }
    }.bind(this)

    var sectionToRender = null;
    if (!this.state.location) {
      sectionToRender = 'location_selector';
    } else if (this.state.genres.length == 0) {
      sectionToRender = 'genre_selector';
    } else {
      sectionToRender = 'event_list';
    }
    return renderSection(sectionToRender);
  }
});

module.exports = Homepage;
