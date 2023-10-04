// Creates a map
import "leaflet"
import NavigationMapView from "src/decidim/navigation_maps/map_view.js";

export default class NavigationMapEditor extends NavigationMapView {
  constructor(map_object, table_object) {
    // Call constructor of superclass to initialize superclass-derived members.
    super(map_object, () => {
      this.createControls();
      if (this.blueprint) {
        this.createAreas();
      }
    });
    this.table_object = table_object;
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

    this.map.on("pm:create", (e) => {
      let geojson = e.layer.toGeoJSON();
      this.blueprint[e.layer._leaflet_id] = geojson;
      this.attachEditorEvents(e.layer);
      this.createAreaCallback(e.layer._leaflet_id, e.layer, this);
    });

    this.map.on("pm:remove", (e) => {
      delete this.blueprint[e.layer._leaflet_id];
      this.removeAreaCallback(e.layer._leaflet_id, e.layer, this);
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
    layer.on("mouseover", (e) => {
      e.target.getElement().classList.add("selected")
    });

    layer.on("mouseout", (e) => {
      e.target.getElement().classList.remove("selected")
    });

    layer.on("pm:edit", (e) => {
      this.blueprint[e.target._leaflet_id] = e.target.toGeoJSON();
      this.editAreaCallback(e.target._leaflet_id, e.target, this);
    });

    layer.on("click", (e) => {
      if (!this.editing()) {
        this.clickAreaCallback(e.target._leaflet_id, e.target, this);
      }
    });
  };

  getBlueprint () {
    return this.blueprint;
  };

}
