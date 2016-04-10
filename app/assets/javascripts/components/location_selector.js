/* global $ */
const React = require('react');

const LocationSelector = React.createClass({
  propTypes: {
    onSelect: React.PropTypes.func,
  },

  getInitialState() {
    return { results: [], };
  },

  componentDidMount() {
    if (this._input !== null) {
      this._input.focus();
    }
  },

  handleKeyDown(e) {
    const q = $(e.target).val();

    // some keypresses don't change the query
    if (q === this.state.lastQuery) {
      return;
    }

    if (this.state.activeAjax) {
      this.state.activeAjax.abort();
    }

    const xhr = $.ajax({
      method: 'GET',
      url: '/api/locations?location[q]=' + q,
    });
    xhr.done(function(data) {
      this.setState({ results: data });
    }.bind(this));

    this.setState({ activeAjax: xhr, lastQuery: q });
  },

  handleLocationSelection(e) {
    const locationId = $(e.target).data('location-id');
    this.setState({ results: [] });
    this.props.onSelect(locationId);
  },

  render() {
    const renderResultList = function(results, clickHandler) {
      const renderResult = function(res) {
        return (
          <li
            onClick={clickHandler}
            key={res[1]}
            data-location-id={res[0]}
            className='location-selector__autocomplete__li'>{res[1]}</li>
        );
      };

      if (results.length > 0) {
        return <ul className='location-selector__autocomplete'>{results.map(renderResult)}</ul>;
      }
    };

    return (
      <div className='location-selector__container'>
        <span className='location-selector__icon'>
          <i className='glyphicon glyphicon-search' />
        </span>
        <input
          ref={function(el) {
            this._input = el;
          }.bind(this)}
          onKeyDown={this.handleKeyDown}
          className='location-selector__input'
          type='text' />
        {renderResultList(this.state.results, this.handleLocationSelection)}
      </div>
    );
  }
});

module.exports = LocationSelector;
