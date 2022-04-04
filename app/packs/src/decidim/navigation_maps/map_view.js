// Creates a map view
import "leaflet";
import "@geoman-io/leaflet-geoman-free";
import "@geoman-io/leaflet-geoman-free/dist/leaflet-geoman.css";

export default class NavigationMapView {
  constructor(map_object, callback) {
    this.features = {};
    this.map_object = map_object;
    this.id = map_object.dataset.id;
    this.image_path = map_object.dataset.image;
    this.blueprint = map_object.dataset.blueprint
      ? JSON.parse(map_object.dataset.blueprint)
      : {};
    this.image = new Image();
    this.image.onload = () => {
      this.createMap();
      if (typeof callback === "function") {
        return callback(this);
      } else if (this.blueprint) {
        this.createAreas();
      }
    };
    this.image.src = this.image_path;
    this.clickAreaCallback = () => {};
    this.setLayerPropertiesCallback = () => {};
  }
  createMap() {
    let bounds = [[0, 0], [this.image.height, this.image.width]];
    this.map = L.map(this.map_object, {
      minZoom: -1,
      maxZoom: 2,
      crs: L.CRS.Simple,
      noWrap: true,
      zoomSnap: 0,
      // zoomDelta: 0.1,
      maxBounds: [[0, 0], [this.image.height, this.image.width]],
      center: [this.image.height / 2, this.image.width / 2],
      zoom: -1,
      scrollWheelZoom: false,
      attributionControl: false
    });

    L.imageOverlay(this.image.src, bounds).addTo(this.map);
    this.fitBounds();
  };

  fitBounds() {
    let image_ratio = this.image.height / this.image.width;
    let map_ratio = this.map_object.offsetHeight / this.map_object.offsetWidth;

    if (image_ratio > map_ratio) {
      this.map.fitBounds([[0, 0], [0, this.image.width]]);
    }
    else {
      this.map.fitBounds([[0, 0], [this.image.height, 0]]);
    }
    this.map.setView([this.image.height / 2, this.image.width / 2]);
  };

  createAreas() {
    this.forEachBlueprint((id, geoarea) => {
      new L.GeoJSON(geoarea, {
        onEachFeature: (feature, layer) => {
          layer._leaflet_id = id;
          this.setLayerProperties(layer, geoarea);
          this.attachEditorEvents(layer);
        }
      }).addTo(this.map);
    });
  };

  setLayerProperties (layer, area) {
    let props = area.properties;
    if (props) {
      if (props.color) {
        layer.setStyle({fillColor: props.color, color: props.color});
      }
      this.setLayerPropertiesCallback(layer, props);
    }
  };

  attachEditorEvents (layer) {
    layer.on("mouseover", (e) => {
      e.target.getElement().classList.add("selected")
    });

    layer.on("mouseout", (e) => {
      e.target.getElement().classList.remove("selected")
    });

    layer.on("click", (e) => {
      this.clickAreaCallback(e.target, this);
    });
  };

  // register callback to handle area clicks
  onClickArea(callback) {
    this.clickAreaCallback = callback;
  };

  onSetLayerProperties(callback) {
    this.setLayerPropertiesCallback = callback;
  };

  forEachBlueprint (decorator) {
    for (let id in this.blueprint) {
      let geoarea = this.blueprint[id];
      // avoid non-polygons for the moment
      if (geoarea.geometry && geoarea.geometry.type !== "Polygon") {
        decorator(id, geoarea);
      }
    }
  };

  reload () {
    if (this.map) {
      this.map.invalidateSize(true);
      this.fitBounds();
    }
  };
}

