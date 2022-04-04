import NavigationMapView from "src/decidim/navigation_maps/map_view.js";
import "jsviews/jsrender";

$(function() {

  let $maps = $(".navigation_maps .map");
  let $tabs = $("#navigation_maps-tabs");
  let maps = {};
  let tmpl = $.templates("#navigation_maps-popup");

  $maps.each(function() {
    let id = $(this).data("id");
    maps[id] = new NavigationMapView(this);
    maps[id].onSetLayerProperties(function(layer, props) {
      if (!props.popup) {
        let node = document.createElement("div");
        let html = tmpl.render(props);
        $(node).html(html);

        layer.bindPopup(node, {
          maxHeight: 400,
          // autoPan: false,
          maxWidth: 640,
          minWidth: 200,
          keepInView: true,
          className: `navigation_map-info map-info-${id}-${layer._leaflet_id}`
        });
      }
    });
    maps[id].onClickArea(function(area) {
      let popup = area.feature.properties && area.feature.properties.link && area.feature.properties.popup;
      if (popup) {
        location = area.feature.properties.link;
      }
    });
  });

  $tabs.on("change.zf.tabs", function(e, $tab, $content) {
    let id = $content.find(".map").data("id");
    maps[id].reload();
  });

});
