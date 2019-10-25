// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//= require leaflet
//= require leaflet-geoman.min
//= require_self

var image = new Image();
image.src = $('#map').data('map');

var map = L.map('map', {
    minZoom: -1,
    maxZoom: 2,
    crs: L.CRS.Simple,
    center: [image.height/4, image.width/2],
    zoom: -1
});

var bounds = [[0,0], [image.height,image.width]];
L.imageOverlay(image.src, bounds).addTo(map);

map.pm.addControls({
  position: 'topleft',
  drawCircle: false,
  cutPolygon: false
});

var blueprint = $('#map').data('blueprint');
for (area in blueprint) {
  var geoarea = blueprint[area];
  var coordinates = $.map(geoarea.geometry.coordinates, function(value, index) {
    var array = $.map(value, function(elem, index) {
      return [elem];
    });
    return array;
  });
  geoarea.geometry.coordinates = [coordinates];

  
  new L.GeoJSON(geoarea, {
    onEachFeature: function(feature, layer) {
      $('#leaflet-body').append('<tr id="leaflet-tr-' + layer._leaflet_id + '"> '
                                    + ' <th id="leaflet-th-' + layer._leaflet_id + '-type">' + feature.geometry.type +'</th>'
                                    + ' <th id="leaflet-th-' + layer._leaflet_id + '-coordinates">' + JSON.stringify(feature.geometry.coordinates[0]) + '</th>'
                                    + ' <th id="leaflet-th-' + layer._leaflet_id + '-link"> <input type="text" id="leaflet-th-' + layer._leaflet_id + '-link-input" value="' + feature.properties.link + '"> </th>'
                                    + '</tr>');
    }
  }).addTo(map);

}


map.invalidateSize();

var features = {};

map.on('pm:create', e => {
  var geojson = e.layer.toGeoJSON();
  features[e.layer._leaflet_id] = geojson;
  $('#leaflet-body').append('<tr id="leaflet-tr-' + e.layer._leaflet_id + '"> '
                                + ' <th id="leaflet-th-' + e.layer._leaflet_id + '-type">' + geojson.geometry.type +'</th>'
                                + ' <th id="leaflet-th-' + e.layer._leaflet_id + '-coordinates">' + JSON.stringify(geojson.geometry.coordinates[0]) + '</th>'
                                + ' <th id="leaflet-th-' + e.layer._leaflet_id + '-link"> <input type="text" id="leaflet-th-' + e.layer._leaflet_id + '-link-input"></th>'
                                + '</tr>');
  e.layer.on('pm:edit', e => {
    features[e.layer._leaflet_id] = e.target.toGeoJSON();
  });
});

map.on('pm:remove', e => {
  delete features[e.layer._leaflet_id];
  document.getElementById('leaflet-tr-' + e.layer._leaflet_id).remove();
});

$('#leaflet-save').click(function(e) {
  e.preventDefault();
  Object.keys(features).forEach(function(key) {
    features[key].properties.link = document.getElementById('leaflet-th-' + key + '-link-input').value;
  });
  $.post({
    url: '/admin/navigation_maps/blueprints',
    data: {blueprint: features},
    dataType: "json"
   });
});

