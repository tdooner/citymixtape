var React = require('react');
var flux = require('fluxify');
var SessionStore = require('components/session_store');

var GenreSelector = React.createClass({
  getDefaultProps: function() {
    return {};
  },

  getInitialState: function() {
    return { activeAjax: null, genres: [] };
  },

  componentDidMount: function() {
    SessionStore.on('change:genres', this.updategenres);
  },

  componentWillUnmount: function() {
    SessionStore.off('change:genres', this.updateGenres);
  },

  updateGenres: function(g, old) {
    this.setState({ genres: g });
  },

  handleKeyUp: function(e) {
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
      url: '/api/genres?q=' + q,
    })
    xhr.done(function(data) {
      this.setState({ genres: data.results });
    }.bind(this));

    this.setState({ activeAjax: xhr, lastQuery: q });
  },

  handleGenreSelection: function(e) {
    var genre = $(e.target).html();
    this.setState({ genres: [] });

    // TODO: Handle multiple genres
    var xhr = $.ajax({
      method: 'POST',
      data: { genre: genre },
      url: '/api/genres',
    })
    xhr.done(function(data) {
      console.log(genre);
      flux.doAction('changeGenres', [genre]);
    }.bind(this));
  },

  render: function() {
    var renderResultList = function(results, clickHandler) {
      var renderResult = function(res) {
        return (
          <li onClick={clickHandler}
              key={res}
              className="location-selector__autocomplete__li">{res}</li>
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
          onKeyUp={this.handleKeyUp}
          className="location-selector__input"
          type="text" />
        {renderResultList(this.state.genres, this.handleGenreSelection)}
      </div>
    );
  }
});

module.exports = GenreSelector;
