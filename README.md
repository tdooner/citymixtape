# City Mixtape

City Mixtape creates a playlist of bands playing near you soon!

## Setup
1. Create a [development Spotify application][1]
2. Add `http://lvh.me:3000/accept` as a redirect URI for your application.
3. Set `SPOTIFY_CLIENT_ID` and `SPOTIFY_CLIENT_SECRET` in your .bashrc to the
   provided values.
4. Run `bin/get-spotify-token` and follow its instructions.
5. Set `SPOTIFY_REFRESH_TOKEN` to the the refresh token stored in
   `.spotify-access-token`
6. Set `SPOTIFY_USER` to the username you just granted the
   access to your new application.
7. Do a bunch more... echonest and songkick are required too.
8. `heroku buildpacks:set heroku/ruby`
9. `heroku buildpacks:add --index 1 heroku/nodejs`

[1]: https://developer.spotify.com/my-applications/
