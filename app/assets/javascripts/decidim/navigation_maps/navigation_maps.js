// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//= require decidim/navigation_maps/map_view
//= require jsrender.min
//= require_self


$(function() {

  var $maps = $('.navigation_maps .map');
  var $tabs = $('#navigation_maps-tabs');
  var maps = {};
  var tmpl = $.templates("#navigation_maps-popup");

  $maps.each(function() {
    var id = $(this).data('id');
    maps[id] = new NavigationMapView(this);
    maps[id].onSetLayerProperties(function(layer, props) {
      if(!props.popup) {
        var node = document.createElement("div");
        var html = tmpl.render(props);
        $(node).html(html);

        layer.bindPopup(node, {
          maxHeight: 400,
          // autoPan: false,
          maxWidth: 640,
          minWidth: 500,
          keepInView: true,
          className: `navigation_map-info map-info-${id}-${layer._leaflet_id}`
        });
      }
    });
    maps[id].onClickArea(function(area) {
      var popup = area.feature.properties && area.feature.properties.link && area.feature.properties.popup;
      if(popup) location = area.feature.properties.link;
    });
  });

  $tabs.on('change.zf.tabs', function(e, $tab, $content) {
    var id = $content.find('.map').data('id');
    maps[id].reload();
  });

});
