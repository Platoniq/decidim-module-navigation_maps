import NavigationMapView from "src/decidim/navigation_maps/map_view";
import initializeElement from "src/decidim/navigation_maps/tabs_manager";
import "jsviews/jsrender";

$(function() {
  let $maps = $(".navigation_maps .map");
  let maps = {};
  let tmpl = $.templates("#navigation_maps-popup");
  let tabs = document.querySelectorAll("#tabs__navigation_maps ul.nav-tabs > li");

  $maps.each(function() {
    // eslint-disable-next-line no-invalid-this
    let id = $(this).data("id");
    // eslint-disable-next-line no-invalid-this
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

  for (let idx = 0; idx < tabs.length; idx += 1) {
    tabs[idx].addEventListener("click", function(event) {
      event.preventDefault();
      const anchorReference = event.target;
      const activePaneId = anchorReference.getAttribute("href");
      const activePane = document.querySelector(activePaneId);
      const id = activePane.querySelector(".map")?.dataset?.id;
      if (id) {
        maps[id].reload();
      }
    });
  }
});

window.addEventListener("load", initializeElement("tabs__navigation_maps"));
