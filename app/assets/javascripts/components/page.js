const React = require('react');

const Page = React.createClass({
  propTypes: {
    children: React.PropTypes.node,
    header: React.PropTypes.string,
  },

  render() {
    return (
      <div style={{ width: '100%' }}>
        <div className='app-logo-container container'>
          <div className='row'>
            <div className='col-xs-12'>
              <a href='/'>
                <img src={'/assets/logo.svg'} className='app-logo' />
                <h1 className='app-wordmark'>City Mixtape</h1>
              </a>
            </div>
          </div>
        </div>

        <div className='app-page'>
          <div className='container'>
            <div className='row'>
              <div className='col-xs-12'>
                <h1>{this.props.header}</h1>
              </div>
            </div>

            <div className='row'>
              <div className='col-xs-12'>
                {this.props.children}
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }
});

module.exports = Page;
