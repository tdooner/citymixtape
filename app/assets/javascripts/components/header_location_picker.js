var React = require('react');
var Homepage = require('components/homepage');
var flux = require('fluxify');

var HeaderLocationPicker = React.createClass({
  updateLocation: function(e) {
    var location = parseInt($(e.target).data('location'))
    console.log('updating location' + location);
    flux.doAction('changeLocation', location);
  },

  /**
   * @return {Object}
   */
  render: function() {
    return (
      <ul className="nav navbar-nav">
        <li><a onClick={this.updateLocation} data-location="26330">San Francisco, CA</a></li>
        <li><a onClick={this.updateLocation} data-location="14700">Cleveland, OH</a></li>
      </ul>
    );
  }
});

module.exports = HeaderLocationPicker;
