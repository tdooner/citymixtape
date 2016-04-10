// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
/* global $ */

$(function() {
  if (process.env.NODE_ENV === 'production') {
    const Client = require('airbrake-js');
    new Client({
      projectId: '122450',
      projectKey: '8dc1ad11e4414db1e7cff67084b8ce78',
    });
  }

  const React = require('react');
  const ReactDOM = require('react-dom');
  const AppContainer = require('components/app_container');

  // This has to be required or else it won't be registered:
  require('components/session_store');

  ReactDOM.render(
    React.createElement(AppContainer),
    document.getElementById('app-container')
  );
});
