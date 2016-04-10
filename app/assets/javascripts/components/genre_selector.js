/* global $ */
const React = require('react');

const GenreSelector = React.createClass({
  propTypes: {
    onSelect: React.PropTypes.func,
  },

  getInitialState() {
    return { activeAjax: null, genres: [] };
  },

  handleKeyUp(e) {
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
      url: '/api/genres?q=' + q,
    });
    xhr.done(function(data) {
      this.setState({ genres: data.results });
    }.bind(this));

    this.setState({ activeAjax: xhr, lastQuery: q });
  },

  handleGenreSelection(e) {
    const genre = $(e.target).html();
    this.setState({ genres: [] });
    this.props.onSelect(genre);
  },

  render() {
    const renderResultList = function(results, clickHandler) {
      const renderResult = function(res) {
        return (
          <li
            onClick={clickHandler}
            key={res}
            className='location-selector__autocomplete__li'>{res}</li>
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
          onKeyUp={this.handleKeyUp}
          className='location-selector__input'
          type='text' />
        {renderResultList(this.state.genres, this.handleGenreSelection)}
      </div>
    );
  }
});

module.exports = GenreSelector;
