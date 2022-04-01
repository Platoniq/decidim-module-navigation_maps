// Creates a map
// = require decidim/navigation_maps/map_view

function NavigationMapEditor(map_object, table_object) {
  let self = this;
  // Call constructor of superclass to initialize superclass-derived members.
  NavigationMapView.call(self, map_object, function() {
    self.createControls();
    if (self.blueprint) {
      self.createAreas();
    }
  });
  self.table_object = table_object;
  this.createAreaCallback = function () {};
  this.editAreaCallback = function () {};
  this.removeAreaCallback = function () {};
}

// NavigationMapEditor derives from NavigationMapView
NavigationMapEditor.prototype = Object.create(NavigationMapView.prototype);
NavigationMapEditor.prototype.constructor = NavigationMapEditor;

NavigationMapEditor.prototype.createControls = function() {
  let self = this;
  self.map.pm.addControls({
    position: "topleft",
    drawCircle: false,
    drawMarker: false,
    drawCircleMarker: false,
    drawPolyline: false,
    cutPolygon: false
  });

  self.map.on("pm:create", function(e) {
    let geojson = e.layer.toGeoJSON();
    self.blueprint[e.layer._leaflet_id] = geojson;
    self.attachEditorEvents(e.layer);
    self.createAreaCallback(e.layer._leaflet_id, e.layer, self);
  });

  self.map.on("pm:remove", function(e) {
    delete self.blueprint[e.layer._leaflet_id];
    self.removeAreaCallback(e.layer._leaflet_id, e.layer, self);
  });
};

NavigationMapEditor.prototype.editing = function() {
  let pm = this.map.pm;
  return pm.globalRemovalEnabled() || pm.globalDragModeEnabled() || pm.globalEditEnabled();
};

// register callback to handle area edits,removals and creations
NavigationMapView.prototype.onCreateArea = function(callback) {
  this.createAreaCallback = callback;
};
NavigationMapView.prototype.onEditArea = function(callback) {
  this.editAreaCallback = callback;
};
NavigationMapView.prototype.onRemoveArea = function(callback) {
  this.removeCreateCallback = callback;
};

NavigationMapEditor.prototype.attachEditorEvents = function (layer) {
  let self = this;

  layer.on("mouseover", function(e) {
    e.target.getElement().classList.add("selected")
  });

  layer.on("mouseout", function(e) {
    e.target.getElement().classList.remove("selected")
  });

  layer.on("pm:edit", function(e) {
    self.blueprint[e.target._leaflet_id] = e.target.toGeoJSON();
    self.editAreaCallback(e.target._leaflet_id, e.target, self);
  });

  layer.on("click", function(e) {
    if (!self.editing()) {
      self.clickAreaCallback(e.target._leaflet_id, e.target, self);
    }
  });
};

NavigationMapEditor.prototype.getBlueprint = function () {
  return this.blueprint;
};
