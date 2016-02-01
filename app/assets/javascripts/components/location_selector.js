var React = require('react');
var flux = require('fluxify');

var LocationSelector = React.createClass({
  handleSubmit: function(e) {
    e.preventDefault();

    $.ajax({
      method: 'POST',
      url: '/api/locations',
      data: { location: { query: 'san francisco, ca.' } }
    }).then(function(data) {
      // TODO: Actually parse response
      // flux.doAction('changeLocation', 26330);
      // 14700
    });
  },

  render: function() {
    return (
      <div>
        <form method="POST" action="/api/location" onSubmit={this.handleSubmit}>
          <input type="text" name="location[query]" />
        </form>
      </div>
    );
  }
});

module.exports = LocationSelector;
