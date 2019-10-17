// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//= require leaflet
//= require leaflet-geoman.min
//= require_self

var image = new Image();
image.src = '/uploads/decidim/navigation_map_homepage_content_block/map_image/11/BASE_navegador_081019.jpg';


var draw = [
    {
      "type": "Feature",
      "properties": {},
      "geometry": {
        "type": "Polygon",
        "coordinates": [
          [
            [515,692.5166625976562],
            [552, 728.5166625976562],
            [1005, 250.51666259765625],
            [970, 216.62916564941406],
            [888.75, 302.62916564941406],
            [872.25, 287.37916564941406],
            [810, 354.7583312988281],
            [806, 351.7583312988281],
            [711, 452.2583312988281],
            [699, 443.2583312988281],
            [672.5, 470.7583312988281],
            [652, 449.7583312988281],
            [625, 480.7583312988281],
            [645, 499.7583312988281],
            [632, 514.2583312988281],
            [659.5, 541.2583312988281],
            [515, 692.5166625976562]
          ]
        ]
      }
    },
    {
      "type": "Feature",
      "properties": {},
      "geometry": {
        "type": "Polygon",
        "coordinates": [
          [
            [1078,106.19999694824219],
            [1112,66.19999694824219],
            [1257,202.1999969482422],
            [1255,273.1999969482422],
            [1078,106.19999694824219]
          ]
        ]
      }
    },
    {
      "type": "Feature",
      "properties": {},
      "geometry": {
        "type": "Polygon",
        "coordinates": [
          [
            [677,656.1999969482422],
            [768,763.1999969482422],
            [710,816.1999969482422],
            [613,709.1999969482422],
            [677,656.1999969482422]
          ]
        ]
      }
    }
  ];

var map = L.map('map', {
    crs: L.CRS.Simple,
    center: [image.width/2, image.height/2],
    zoom: 0,
});

var bounds = [[0,0], [image.height,image.width]];
L.imageOverlay(image.src, bounds).addTo(map);
L.geoJSON(draw).addTo(map);
map.fitBounds(bounds);

map.invalidateSize();

