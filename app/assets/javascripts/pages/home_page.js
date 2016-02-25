var React = require('react');
var LocationSelector = require('components/location_selector');

var HomePage = React.createClass({
  render: function() {
    return (
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
  }
});

module.exports = HomePage;
