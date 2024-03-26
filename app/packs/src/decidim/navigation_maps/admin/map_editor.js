// Creates a map
import "leaflet"
import NavigationMapView from "src/decidim/navigation_maps/map_view";

export default class NavigationMapEditor extends NavigationMapView {
  constructor(mapObject, tableObject) {
    // Call constructor of superclass to initialize superclass-derived members.
    super(mapObject, () => {
      this.createControls();
      if (this.blueprint) {
        this.createAreas();
      }
    });
    this.tableObject = tableObject;
    this.createAreaCallback = function () {};
    this.editAreaCallback = function () {};
    this.removeAreaCallback = function () {};
  }

  createControls() {
    this.map.pm.addControls({
      position: "topleft",
      drawCircle: false,
      drawMarker: false,
      drawCircleMarker: false,
      drawPolyline: false,
      cutPolygon: false
    });

    this.map.on("pm:create", (event) => {
      let geojson = event.layer.toGeoJSON();
      this.blueprint[event.layer._leaflet_id] = geojson;
      this.attachEditorEvents(event.layer);
      this.createAreaCallback(event.layer._leaflet_id, event.layer, this);
    });

    this.map.on("pm:remove", (event) => {
      // eslint-disable-next-line prefer-reflect
      delete this.blueprint[event.layer._leaflet_id];
      this.removeAreaCallback(event.layer._leaflet_id, event.layer, this);
    });
  };

  editing() {
    let pm = this.map.pm;
    return pm.globalRemovalEnabled() || pm.globalDragModeEnabled() || pm.globalEditEnabled();
  };

  // register callback to handle area edits,removals and creations
  onCreateArea(callback) {
    this.createAreaCallback = callback;
  };
  onEditArea(callback) {
    this.editAreaCallback = callback;
  };
  onRemoveArea(callback) {
    this.removeCreateCallback = callback;
  };

  attachEditorEvents (layer) {
    layer.on("mouseover", (event) => {
      event.target.getElement().classList.add("selected")
    });

    layer.on("mouseout", (event) => {
      event.target.getElement().classList.remove("selected")
    });

    layer.on("pm:edit", (event) => {
      this.blueprint[event.target._leaflet_id] = event.target.toGeoJSON();
      this.editAreaCallback(event.target._leaflet_id, event.target, this);
    });

    layer.on("click", (event) => {
      if (!this.editing()) {
        this.clickAreaCallback(event.target._leaflet_id, event.target, this);
      }
    });
  };

  getBlueprint () {
    return this.blueprint;
  };
}
