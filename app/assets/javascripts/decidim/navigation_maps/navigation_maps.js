// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//= require decidim/navigation_maps/map_view
//= require_self


$(function() {

  var $maps = $('.navigation_maps .map');
  var $tabs = $('#navigation_maps-tabs');
  var maps = {};

  $maps.each(function() {
    var id = $(this).data('id');
    maps[id] = new NavigationMapView(this);
    maps[id].onClickArea(function(area) {
      if(area.feature.properties && area.feature.properties.link) location = area.feature.properties.link;
    });
  });

  $tabs.on('change.zf.tabs', function(e, $tab, $content) {
    var id = $content.find('.map').data('id');
    maps[id].reload();
  });

});
