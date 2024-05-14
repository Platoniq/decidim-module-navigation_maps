import NavigationMapView from "src/decidim/navigation_maps/map_view";
import "jsviews/jsrender";

document.addEventListener("DOMContentLoaded", () => {
  const maps = {};
  const tmpl = $.templates("#navigation_maps-popup");
  const tabs = document.getElementById("navigation_maps-tabs");

  document.querySelectorAll(".navigation_maps .map").forEach((element) => {
    const id = element.dataset.id;
    maps[id] = new NavigationMapView(element);
    maps[id].onSetLayerProperties((layer, props) => {
      if (!props.popup) {
        let node = document.createElement("div");
        node.innerHTML = tmpl.render(props);

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
    maps[id].onClickArea((area) => {
      const popup = area.feature.properties && area.feature.properties.link && area.feature.properties.popup;
      if (popup) {
        location = area.feature.properties.link;
      }
    });
  });

  $(tabs).on("change.zf.tabs", (_event, _tab, $content) => maps[$content.find(".map").data("id")].reload());
});

$(".home__section.navigation_maps").foundation();
