var React = require('react');
var SessionStore = require('components/session_store');

var EventList = React.createClass({
  getInitialState: function() {
    return { loading: true, locationId: null, results: null };
  },

  updateLocation: function(locationId, previousLocationId) {
    this.setState({ loading: true, locationId: locationId });

    $.ajax({
      method: 'GET',
      url: '/api/locations/' + locationId + '/events',
    }).done(function(data) {
      this.setState({ loading: false, results: data });
    }.bind(this));
  },

  componentWillMount: function() {
    SessionStore.on('change:location', this.updateLocation);
  },

  componentWillUnmount: function() {
    // SessionStore.off('change:location', this.updateLocation);
  },

  render: function() {
    if (this.state.loading) {
      return <div>Loading...</div>
    }

    var renderRow = function(row) {
      return (
        <tr key={row.id}>
          <td>{row.display_name}</td>
          <td>{row.venue.display_name}</td>
          <td>{row.start}</td>
        </tr>
      );
    }

    return <div>
      <table>
        <tbody>
          {this.state.results.map(renderRow)}
        </tbody>
      </table>
    </div>;
  }
});

module.exports = EventList;
