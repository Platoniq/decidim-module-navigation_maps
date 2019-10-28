// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//= require leaflet
//= require leaflet-geoman.min
//= require_self

function MapView(image_path, blueprint) {
  var self = this;
  self.features = {};
  self.blueprints = blueprint || {};
  self.image = new Image();
  self.image.onload = function() {
    self.createMap();
  }
  self.image.src = image_path;
  
}

MapView.prototype.createMap = function() {
  var self = this;
  self.map = L.map('map', {
    minZoom: -1,
    maxZoom: 2,
    crs: L.CRS.Simple,
    center: [self.image.height/2,self.image.width/2],
    zoom: -1,
  });

  var bounds = [[0,0], [self.image.height,self.image.width]];
  L.imageOverlay(self.image.src, bounds).addTo(self.map);

  if(self.blueprints) {
    self.createAreas();
  }
}

MapView.prototype.createAreas = function() {
  var self = this;
  for (area in self.blueprints) {
    var geoarea = self.blueprints[area];
    if(geoarea.geometry.type !== 'Polygon') continue;

    new L.GeoJSON(geoarea, {
      onEachFeature: function(feature, layer) {
        layer.on('click', function(e) {
          if(feature.properties && feature.properties.link) location = feature.properties.link;
        })
      }
    }).addTo(self.map);
  }
}

$(function() {
  new MapView($('#map').data('map'), $('#map').data('blueprint'));
});