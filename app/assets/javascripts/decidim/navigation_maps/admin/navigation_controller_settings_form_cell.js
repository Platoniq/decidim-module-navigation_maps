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

map.invalidateSize();

var features = [];

map.on('pm:create', e => {
  features[e.layer._leaflet_id] = e.layer.toGeoJSON();
  e.layer.on('pm:edit', e => {
    features[e.target._leaflet_id] = e.target.toGeoJSON();
  });
});

map.on('pm:remove', e => {
  features.pop(e.layer.toGeoJSON());
});

$('#leaflet-save').click(function(e) {
  e.preventDefault();
  console.info(features);
  $.post({
    url: '/admin/navigation_maps/blueprints',
    data: {blueprint: features},
    dataType: "json"
   });
});

