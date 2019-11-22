// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//= require leaflet
//= require leaflet-geoman.min
//= require decidim/navigation_maps/map_view
//= require_self


$(function() {

  var $maps = $('.navigation_maps .map');
  var $tabs = $('#navigation_maps-tabs');
  var maps = {};

  $maps.each(function() {
    maps[$(this).data('id')] = new NavigationMapView(this);
  });

  $tabs.on('change.zf.tabs', function(e, $tab, $content) {
    var id = $content.find('.map').data('id');
    maps[id].reload();
  });

});