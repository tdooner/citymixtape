const React = require('react');

const Router = require('react-router').Router;
const Route = require('react-router').Route;
const browserHistory = require('react-router').browserHistory;

const HomePage = require('pages/home_page');
const GenrePage = require('pages/genre_page');
const EventListPage = require('pages/event_list_page');
const PlaylistPage = require('pages/playlist_page');

const AppContainer = React.createClass({
  render() {
    return (
      <Router history={browserHistory}>
        <Route path='/' component={HomePage} />
        <Route path='/genres' component={GenrePage} />
        <Route path='/events' component={EventListPage} />
        <Route path='/playlist' component={PlaylistPage} />
      </Router>
    );
  }
});

module.exports = AppContainer;
