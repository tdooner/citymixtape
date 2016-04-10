const React = require('react');
const flux = require('fluxify');

const browserHistory = require('react-router').browserHistory;

const LocationSelector = require('components/location_selector');
const Page = require('components/page');

const HomePage = React.createClass({
  _handleLocationSelection(locationId) {
    flux.doAction('changeLocation', locationId);
    browserHistory.push('/genres');
  },

  render() {
    return (
      <Page header='Where do you live?'>
        <p>Your playlist will only include bands that are
        performing soon in this general area.</p>

        <LocationSelector onSelect={this._handleLocationSelection} />
      </Page>
    );
  }
});

module.exports = HomePage;
