// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//= require leaflet
//= require leaflet-geoman.min
//= require_self

function loadMap(image, blueprint) {
  var map = L.map('map', {
    minZoom: -1,
    maxZoom: 2,
    crs: L.CRS.Simple,
    center: [image.height/2,image.width/2],
    zoom: -1,
  });

  var bounds = [[0,0], [image.height,image.width]];
  L.imageOverlay(image.src, bounds).addTo(map);

  if(blueprint) {
    for (area in blueprint) {
      var geoarea = blueprint[area];
      if(geoarea.geometry.type !== 'Polygon') continue;
      console.log(geoarea)
      var coordinates = $.map(geoarea.geometry.coordinates, function(value, index) {
        var array = $.map(value, function(elem, index) {
          return [elem];
        });
        return array;
      });
      geoarea.geometry.coordinates = [coordinates];

      new L.GeoJSON(geoarea, {
        onEachFeature: function(feature, layer) {
          layer.on('click', function(e) {
            // window.open(feature.properties.link, '_blank');
            if(feature.properties && feature.properties.link) location = feature.properties.link;
          })
        }
      }).addTo(map);
    }
  }

  map.invalidateSize();
}

$(function() {
  var image = new Image();
  image.onload = function () {
    loadMap(image, $('#map').data('blueprint'));
  }
  image.src = $('#map').data('map');
});