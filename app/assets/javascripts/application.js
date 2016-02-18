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
//= require_tree ./components
//= require_tree .

$(function() {
  var React = require('react'),
      ReactDOM = require('react-dom');
  var Homepage = require('components/homepage');
  var flux = require('fluxify');
  //var HeaderLocationPicker = require('components/header_location_picker');

  // This has to be required or else it won't be registered:
  require('components/session_store');

  if (window.bootstrap && window.bootstrap.stars) {
    flux.doAction('updateStars', window.bootstrap.stars)
  }

  var homepageProps = {};

  if (window.bootstrap && window.bootstrap.metroArea) {
    homepageProps['initialSearchQuery'] = window.bootstrap.metroArea.name;
    flux.doAction('changeLocation', window.bootstrap.metroArea.id)
  }

  //var LocationSelector = require('components/location_selector');
  ReactDOM.render(
    React.createElement(Homepage, homepageProps),
    document.getElementById("app-container")
  );
});
