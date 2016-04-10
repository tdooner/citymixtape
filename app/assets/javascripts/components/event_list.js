const React = require('react');
const Star = require('components/star');

const EventList = React.createClass({
  propTypes: {
    events: React.PropTypes.array,
  },

  render() {
    const renderEvent = function(event) {
      return (
        <li className='event-list__list-item'>
          <Star objectId={event.id} objectType='artist' />
          <span>{event.display_name}</span>
        </li>
      );
    };

    return (
      <div>
        <ul className='event-list__list'>
          {this.props.events.map(renderEvent)}
        </ul>
      </div>
    );
  }
});

module.exports = EventList;
