var React = require('react');
var SessionStore = require('components/session_store');

var PlaylistPage = React.createClass({
  componentDidMount: function() {
    SessionStore.on('change:playlistUrl', this.playlistUrl);
  },

  componentWillUnmount: function() {
    SessionStore.off('change:playlistUrl', this.playlistUrl);
  },

  updateplaylistUrl: function(previousplaylistUrl, playlistUrl) {
    this.forceUpdate();
  },

  render: function() {
    return <div>
      <h2>Playlist Created!</h2>
      <p><a href={SessionStore.playlistUrl} target="_blank">Open Playlist!</a></p>
    </div>;
  }
});

module.exports = PlaylistPage;
