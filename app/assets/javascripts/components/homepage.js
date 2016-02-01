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
    var innerC;
    if (!this.state.location) {
      innerC = <LocationSelector />
    } else {
      innerC = <EventList locationId={this.state.location} />;
    }

    return <div>{innerC}</div>;
  },
});

module.exports = Homepage;
