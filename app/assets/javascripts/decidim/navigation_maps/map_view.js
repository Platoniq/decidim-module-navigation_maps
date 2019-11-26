// Creates a map view

function NavigationMapView(map_object, callback) {
  var self = this;
  self.features = {};
  self.map_object = map_object;
  self.id = map_object.dataset.id;
  self.image_path = map_object.dataset.image;
  self.blueprint = map_object.dataset.blueprint ? JSON.parse(map_object.dataset.blueprint) : {};
  self.image = new Image();
  self.image.onload = function() {
    self.createMap();
    if(typeof callback === "function") {
      callback(self);
    } else {
      if(self.blueprint) {
        self.createAreas();
      }
    }
  };
  self.image.src = self.image_path;
  this.clickAreaCallback = function () {};
}

NavigationMapView.prototype.createMap = function() {
  var bounds = [[0,0], [this.image.height,this.image.width]];

  this.map = L.map(this.map_object, {
      minZoom: -1,
      maxZoom: 2,
      crs: L.CRS.Simple,
      noWrap: true,
      zoomSnap: 0,
      zoomDelta: 0.1,
      maxBounds: [[0,0], [this.image.height,this.image.width]],
      center: [this.image.height/2, this.image.width/2],
      zoom: -1
  });

  L.imageOverlay(this.image.src, bounds).addTo(this.map);
  this.fitBounds();
};

NavigationMapView.prototype.fitBounds = function() {
  var image_ratio = this.image.height / this.image.width;
  var map_ratio = this.map_object.offsetHeight / this.map_object.offsetWidth;

  if(image_ratio > map_ratio) {
    this.map.fitBounds([[0,0], [0,this.image.width]]);
  }
  else {
    this.map.fitBounds([[0,0], [this.image.height,0]]);
  }
  this.map.setView([this.image.height/2, this.image.width/2]);
};

NavigationMapView.prototype.createAreas = function() {
  var self = this;
  self.forEachBlueprint(function(id, geoarea) {
    new L.GeoJSON(geoarea, {
      onEachFeature: function(feature, layer) {
        layer._leaflet_id = id;

        layer.on('mouseover', function(e) {
          e.target.getElement().classList.add('selected')
        });

        layer.on('mouseout', function(e) {
          e.target.getElement().classList.remove('selected')
        });

        layer.on('click', function(e) {
          self.clickAreaCallback(e.target, self);
        });
      }
    }).addTo(self.map);
  });
};

// register callback to handle area clicks
NavigationMapView.prototype.onClickArea = function(callback) {
  this.clickAreaCallback = callback;
};

NavigationMapView.prototype.forEachBlueprint = function (callback) {
  for (var id in this.blueprint) {
    var geoarea = this.blueprint[id];
    // avoid non-polygons for the moment
    if(!geoarea.geometry || geoarea.geometry.type !== 'Polygon') continue;
    callback(id, geoarea);
  }
};

NavigationMapView.prototype.reload = function () {
  if(this.map) {
    this.map.invalidateSize(true);
    this.fitBounds();
  }
};
