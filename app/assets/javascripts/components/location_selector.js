var React = require('react');
var flux = require('fluxify');

var LocationSelector = React.createClass({
  getInitialState: function() {
    return { results: [] };
  },

  handleKeyDown: function(e) {
    $.ajax({
      method: 'GET',
      url: '/api/locations?location[q]=' + $(e.target).val(),
    }).then(function(data) {
      this.setState({ results: data });
    }.bind(this));
  },

  handleLocationSelection: function(e) {
    var locationId = $(e.target).data('location-id');
    flux.doAction('changeLocation', locationId);
  },

  render: function() {
    var focusThis = function(self) {
      if (self != null) {
        self.focus();
      }
    }

    var renderResultList = function(results, clickHandler) {
      var renderResult = function(res) {
        return (
          <li onClick={clickHandler}
              key={res[0]}
              data-location-id={res[0]}
              className="location-selector__autocomplete__li">{res[1]}</li>
        );
      }

      if (results.length > 0) {
        return <ul className="location-selector__autocomplete">{results.map(renderResult)}</ul>;
      }
    }

    return (
      <div className="location-selector__container">
        <span className="location-selector__icon">
          <i className="glyphicon glyphicon-search" />
        </span>
        <input ref={focusThis}
          onKeyDown={this.handleKeyDown}
          className="location-selector__input"
          type="text" />
        {renderResultList(this.state.results, this.handleLocationSelection)}
      </div>
    );
  }
});

module.exports = LocationSelector;
