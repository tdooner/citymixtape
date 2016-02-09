var React = require('react');
var LocationSelector = require('components/location_selector');
var EventList = require('components/event_list');
var SessionStore = require('components/session_store');

var Homepage = React.createClass({
  getInitialState: function() {
    return { location: SessionStore.location };
  },

  updateLocation: function(locationId, previousLocationId) {
    this.setState({ location: locationId });
  },

  componentDidMount: function() {
    SessionStore.on('change:location', this.updateLocation);
  },

  componentWillUnmount: function() {
    SessionStore.off('change:location', this.updateLocation);
  },

  render: function() {
    return (
      <div style={ { width: "100%", height: "100%" } }>
        <div className="page1">
          <div className="container">
            <div className="row">
              <div className="col-xs-12">
                <h1>My Town Playlist</h1>
              </div>
            </div>

            <div className="row">
              <div className="col-xs-12">
                <LocationSelector />
              </div>
            </div>
          </div>
        </div>

        <div className="container">
          <div className="row">
            <div className="col-xs-12">
              <EventList />
            </div>
          </div>
        </div>
      </div>
    );
  }
});

module.exports = Homepage;
