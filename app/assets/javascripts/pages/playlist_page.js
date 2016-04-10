/* global $ */
const React = require('react');
const flux = require('fluxify');

const Page = require('components/page');
const SessionStore = require('components/session_store');

const PlaylistPage = React.createClass({
  getInitialState() {
    return { playlistUrl: null };
  },

  componentDidMount() {
    SessionStore.on('change:playlistUrl', this.playlistUrl);
    SessionStore.on('change', this.forceUpdate);
  },

  componentWillUnmount() {
    SessionStore.off('change:playlistUrl', this.playlistUrl);
    SessionStore.off('change', this.forceUpdate);
  },

  updateplaylistUrl(previousplaylistUrl, playlistUrl) {
    this.setState({ playlistUrl: playlistUrl });
  },

  handleCreatePlaylistClick() {
    const firstName = this._name.value;
    const email = this._email.value;
    const enable = this._enable.checked;
    console.log(enable);

    if (!firstName.length) {
      this.setState({ error: 'First name is empty!' });
      return;
    }

    if (!email.length) {
      this.setState({ error: 'Email is empty!' });
      return;
    }

    $.ajax({
      method: 'POST',
      url: '/api/locations/' + SessionStore.location + '/playlist',
      data: {
        first_name: firstName,
        email: email,
        enable: enable,
      },
    }).done(function(data) {
      flux.doAction('changePlaylistUrl', data.spotify_uri);
    });
  },

  render() {
    const renderPlaylistUrl = (
      <Page header='Playlist created!'>
        <p><a href={this.state.playlistUrl} target='_blank'>Open Playlist!</a></p>
      </Page>
    );

    const renderForm = (
      <Page header='One last thing!'>
        <div>
          {this.state.error && <div style={{ color: '#f00' }}>{this.state.error}</div>}
          <fieldset className='form-group row'>
            <label className='col-xs-2' htmlFor='name'>First Name</label>
            <div className='col-xs-4'>
              <input ref={(e) => this._name = e} className='form-control' name='name' type='text' />
            </div>
          </fieldset>

          <fieldset className='form-group row'>
            <label className='col-xs-2' htmlFor='name'>Email</label>
            <div className='col-xs-4'>
              <input ref={(e) => this._email = e} className='form-control' name='email' type='email' />
            </div>
          </fieldset>

          <div className='checkbox'>
            <div className='col-xs-offset-2 col-xs-4'>
              <p>You will be emailed a link to edit this playlist later.</p>
              <label>
                <input ref={(e) => this._enable = e} name='enable_newsletter' defaultChecked type='checkbox' />
                Also email me a weekly summary
              </label>
            </div>
          </div>
        </div>

        <div className="row">
          <div className="col-xs-12">
            <a href='#' onClick={this.handleCreatePlaylistClick}>Create Spotify Playlist</a>
          </div>
        </div>
      </Page>
    );

    return this.state.playlistUrl ? renderPlaylistUrl : renderForm;
  }
});

module.exports = PlaylistPage;
