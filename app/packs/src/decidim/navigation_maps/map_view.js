// Creates a map view
import "leaflet/dist/leaflet.css";
import "@geoman-io/leaflet-geoman-free";
import "@geoman-io/leaflet-geoman-free/dist/leaflet-geoman.css";

export default class NavigationMapView {
  constructor(mapObject, imageDecorator) {
    this.features = {};
    this.mapObject = mapObject;
    this.id = mapObject.dataset.id;
    this.imagePath = mapObject.dataset.image;
    this.blueprint = mapObject.dataset.blueprint
      ? JSON.parse(mapObject.dataset.blueprint)
      : {};
    this.image = new Image();
    this.image.onload = () => {
      this.createMap();
      if (typeof imageDecorator === "function") {
        imageDecorator(this);
      } else if (this.blueprint) {
        this.createAreas();
      }
    };
    this.image.src = this.imagePath;
    this.clickAreaCallback = () => {};
    this.setLayerPropertiesCallback = () => {};
  }

  createMap() {
    const bounds = [[0, 0], [this.image.height, this.image.width]];
    this.map = L.map(this.mapObject, {
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
    const imageRatio = this.image.height / this.image.width;
    const mapRatio = this.mapObject.offsetHeight / this.mapObject.offsetWidth;

    if (imageRatio > mapRatio) {
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
          // eslint-disable-next-line camelcase
          layer._leaflet_id = id;
          this.setLayerProperties(layer, geoarea);
          this.attachEditorEvents(layer);
        }
      }).addTo(this.map);
    });
  };

  setLayerProperties (layer, area) {
    const props = area.properties;
    if (props) {
      if (props.color) {
        layer.setStyle({fillColor: props.color, color: props.color});
      }
      this.setLayerPropertiesCallback(layer, props);
    }
  };

  attachEditorEvents (layer) {
    layer.on("mouseover", (event) => {
      event.target.getElement().classList.add("selected")
    });

    layer.on("mouseout", (event) => {
      event.target.getElement().classList.remove("selected")
    });

    layer.on("click", (event) => {
      this.clickAreaCallback(event.target, this);
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
    // eslint-disable-next-line guard-for-in
    for (let id in this.blueprint) {
      const geoarea = this.blueprint[id];
      // avoid non-polygons for the moment
      if (geoarea.geometry && geoarea.geometry.type === "Polygon") {
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

