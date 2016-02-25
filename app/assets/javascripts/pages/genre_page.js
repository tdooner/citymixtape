var React = require('react');
var GenreSelector = require('components/genre_selector');

var GenrePage = React.createClass({
  render: function() {
    return (
      <div className="app-page app-page2 container">
        <div className="row">
          <div className="col-xs-12">
            <h1>Favorite Genre?</h1>
            <p>This will improve song recommendations.</p>

            <GenreSelector />
          </div>
        </div>
      </div>
    );
  }
});

module.exports = GenrePage;
