import NavigationMapView from "src/decidim/navigation_maps/map_view";
import initializeElement from "src/decidim/navigation_maps/tabs_manager";
import "jsviews/jsrender";

document.addEventListener("DOMContentLoaded", () => {
  const maps = {};
  const tmpl = $.templates("#navigation_maps-popup");
  const tabs = document.querySelectorAll("#tabs__navigation_maps ul.nav-tabs > li");

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

  for (let idx = 0; idx < tabs.length; idx += 1) {
    tabs[idx].addEventListener("click", (event) => {
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
