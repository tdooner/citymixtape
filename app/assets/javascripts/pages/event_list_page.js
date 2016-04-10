/* global $ */
const NProgress = require('nprogress');
const React = require('react');
const flux = require('fluxify');

const Page = require('components/page');

const browserHistory = require('react-router').browserHistory;

const EventList = require('components/event_list');
const SessionStore = require('components/session_store');

const EventListPage = React.createClass({
  getInitialState() {
    return {
      loading: true,
      results: null,
      city: null,
    };
  },

  componentDidMount() {
    NProgress.configure({ trickleSpeed: 100 });
    NProgress.start();

    $.ajax({
      method: 'GET',
      url: '/api/locations/' + SessionStore.location + '/events',
    }).done(function(data) {
      this.setState({ loading: false, events: data.events, city: data.city });
      NProgress.done();
    }.bind(this));
  },

  componentWillUnmount() {
    NProgress.done();
  },

  handleResetLocation() {
    flux.doAction('changeLocation', null);
  },

  render() {
    if (this.state.loading) {
      return (
        <Page header='Loading...' />
      );
    }

    return (
      <Page header={`Bands coming to ${this.state.city}`}>
        <p>
          Pick about 10 bands you like. This will help us create a playlist for you.
        </p>
        <button onClick={function() { browserHistory.push('/playlist') }} value='Done' />
        <EventList
          loading={this.state.loading}
          locationId={SessionStore.location}
          events={this.state.events}
        />
      </Page>
    );
  }
});

module.exports = EventListPage;
