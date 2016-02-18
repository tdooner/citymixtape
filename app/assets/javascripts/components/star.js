var React = require('react');
var flux = require('fluxify');
var SessionStore = require('components/session_store');

var Star = React.createClass({
  propTypes: {
    objectType: React.PropTypes.string.isRequired,
    objectId: React.PropTypes.number.isRequired
  },

  getInitialState: function() {
    var starKey = this.props.objectType + '-' + this.props.objectId

    return { starred: (SessionStore.stars.indexOf(starKey) !== -1) };
  },

  componentDidMount: function() {
    SessionStore.on('change:stars', this.updateStarredness);
  },

  componentWillUnmount: function() {
    SessionStore.off('change:stars', this.updateStarredness);
  },

  updateStarredness: function(stars, lastStars) {
    var starKey = this.props.objectType + '-' + this.props.objectId

    this.setState({ starred: (stars.indexOf(starKey) !== -1) })
  },

  handleClick: function(e) {
    e.preventDefault()
    var method = this.state.starred ? 'DELETE' : 'POST'

    $.ajax({
      method: method,
      url: '/api/stars/' + this.props.objectType + '/' + this.props.objectId,
    }).then(function(data) {
      flux.doAction('updateStars', data);

      if (this.state.starred) {
        this.setState({ starred: false });
      } else {
        this.setState({ starred: true });
      }
    }.bind(this))
  },

  render: function() {
    var className = "glyphicon"
    if (this.state.starred) {
      className += " glyphicon-star"
    } else {
      className += " glyphicon-star-empty"
    }

    return (
      <a href="#" onClick={this.handleClick} className={className}></a>
    );
  }
});

module.exports = Star;
