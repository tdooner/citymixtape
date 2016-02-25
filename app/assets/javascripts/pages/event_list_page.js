var React = require('react')
var EventList = require('components/event_list');

var EventListPage = React.createClass({
  render: function() {
    return (
      <div className="app-page app-page3 container">
        <div className="row">
          <div className="col-xs-12">
            <EventList />
          </div>
        </div>
      </div>
    );
  }
});

module.exports = EventListPage;
