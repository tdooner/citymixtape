/* global $ */
const React = require('react');
const flux = require('fluxify');
const browserHistory = require('react-router').browserHistory;

const GenreSelector = require('components/genre_selector');
const Page = require('components/page');

const GenrePage = React.createClass({
  _handleGenreSelection(genre) {
    const xhr = $.ajax({
      method: 'POST',
      data: { genre: genre },
      url: '/api/genres',
    });
    xhr.done(function() {
      flux.doAction('changeGenres', [genre]);
      browserHistory.push('/events');
    });
  },

  render() {
    return (
      <Page header='Favorite Genre?'>
        <p>This will help us make a playlist that has artist you actually like.</p>
        <GenreSelector onSelect={this._handleGenreSelection} />
      </Page>
    );
  }
});

module.exports = GenrePage;
