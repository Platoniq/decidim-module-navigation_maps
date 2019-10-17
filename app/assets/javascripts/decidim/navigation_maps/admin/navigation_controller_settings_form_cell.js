// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//= require leaflet
//= require leaflet-geoman.min
//= require_self

var image = new Image();
image.src = '/uploads/decidim/navigation_map_homepage_content_block/map_image/11/BASE_navegador_081019.jpg'

var map = L.map('map', {
    crs: L.CRS.Simple,
    center: [0,0],
    zoom: 1
});


var bounds = [[0,0], [image.height,image.width]];
L.imageOverlay(image.src, bounds).addTo(map);
map.fitBounds(bounds);

map.pm.addControls({
  position: 'topleft',
  drawCircle: false,
  cutPolygon: false
});

map.invalidateSize();

var features = [];

map.on('pm:create', e => {
  features.push(e.layer.toGeoJSON());
});

map.on('pm:remove', e => {
  features.pop(e.layer.toGeoJSON());
});

$('#leaflet-save').click(function() {
  console.info(features);
  return features;
});

