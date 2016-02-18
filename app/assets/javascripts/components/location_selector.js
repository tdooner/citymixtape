var React = require('react');
var flux = require('fluxify');

var LocationSelector = React.createClass({
  getDefaultProps: function() {
    return { initialSearchQuery: "" };
  },

  getInitialState: function() {
    return { results: [], lastQuery: this.props.initialSearchQuery };
  },

  componentDidMount: function() {
    if (this._input != null) {
      this._input.focus();
      $(this._input).val(this.props.initialSearchQuery);
    }
  },

  handleKeyDown: function(e) {
    var q = $(e.target).val();

    // some keypresses don't change the query
    if (q === this.state.lastQuery) {
      return
    }

    if (this.state.activeAjax) {
      this.state.activeAjax.abort();
    }

    var xhr = $.ajax({
      method: 'GET',
      url: '/api/locations?location[q]=' + q,
    })
    xhr.done(function(data) {
      this.setState({ results: data });
    }.bind(this));

    this.setState({ activeAjax: xhr, lastQuery: q });
  },

  handleLocationSelection: function(e) {
    var locationId = $(e.target).data('location-id');
    this.setState({ results: [] });

    flux.doAction('changeLocation', locationId);
  },

  render: function() {
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
        <input ref={function(el) { this._input = el; }.bind(this)}
          onKeyDown={this.handleKeyDown}
          className="location-selector__input"
          type="text" />
        {renderResultList(this.state.results, this.handleLocationSelection)}
      </div>
    );
  }
});

module.exports = LocationSelector;
