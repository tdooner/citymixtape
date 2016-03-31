var React = require('react')
var EventList = require('components/event_list');
var SessionStore = require('components/session_store');

var EventListPage = React.createClass({
  componentDidMount: function() {
    SessionStore.on('change:location', this.updateLocation);
  },

  componentWillUnmount: function() {
    SessionStore.off('change:location', this.updateLocation);
  },

  updateLocation: function(previousLocationId, locationId) {
    this.forceUpdate();
  },

  render: function() {
    return (
      <div className="app-page app-page3 container">
        <div className="row">
          <div className="col-xs-12">
            <EventList locationId={SessionStore.location} />
          </div>
        </div>
      </div>
    );
  }
});

module.exports = EventListPage;
