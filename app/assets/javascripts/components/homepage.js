var React = require('react');
var LocationSelector = require('components/location_selector');
var EventList = require('components/event_list');
var SessionStore = require('components/session_store');

var Homepage = React.createClass({
  getDefaultProps: function() {
    return { initialSearchQuery: "" };
  },

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
              <LocationSelector initialSearchQuery={this.props.initialSearchQuery} />
            </div>
          </div>
        </div>
      );

      var page2 = (
        <div className="app-page app-page2 container">
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
        case 'event_list':
          return page2;
          break;
      }
    }.bind(this)

    var sectionToRender = !!this.state.location ? 'event_list' : 'location_selector'

    return renderSection(sectionToRender);
  }
});

module.exports = Homepage;
