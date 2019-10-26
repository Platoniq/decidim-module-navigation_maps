// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//= require leaflet
//= require leaflet-geoman.min
//= require jquery.form
//= require_self

function MapEditor(image_path, blueprint) {
  var self = this;
  self.features = {};
  self.blueprint = blueprint;
  self.image = new Image();
  self.image.onload = function() {
    self.createMap();
  }
  self.image.src = image_path;
}

MapEditor.prototype.createMap = function() {
  var self = this;
  self.map = L.map('map', {
      minZoom: -1,
      maxZoom: 2,
      crs: L.CRS.Simple,
      center: [self.image.height/2, self.image.width/2],
      zoom: -1
  });

  var bounds = [[0,0], [self.image.height,self.image.width]];
  L.imageOverlay(self.image.src, bounds).addTo(self.map);

  self.map.pm.addControls({
    position: 'topleft',
    drawCircle: false,
    drawMarker: false,
    drawCircleMarker: false,
    drawPolyline: false,
    cutPolygon: false
  });

  if(self.blueprint) {
    self.createAreas();
  }

  self.map.invalidateSize();

  self.map.on('pm:create', function(e) {
    var geojson = e.layer.toGeoJSON();
    console.log(e.layer._leaflet_id, geojson)
    self.blueprint[e.layer._leaflet_id] = geojson;
    self.renderTr(e.layer._leaflet_id, geojson);
    e.layer.on('pm:edit', function(e) {
      self.blueprint[e.layer._leaflet_id] = e.target.toGeoJSON();
    });
  });

  self.map.on('pm:remove', function(e) {
    delete self.blueprint[e.layer._leaflet_id];
    document.getElementById('leaflet-tr-' + e.layer._leaflet_id).remove();
  });
};

MapEditor.prototype.createAreas = function() {
  var self = this;
  for (area in self.blueprint) {
    var geoarea = self.blueprint[area];
    if(geoarea.geometry.type !== 'Polygon') continue;
    var coordinates = $.map(geoarea.geometry.coordinates, function(value, index) {
      return $.map(value, function(elem, index) {
        return [elem];
      });
    });
    geoarea.geometry.coordinates = [coordinates];

    new L.GeoJSON(geoarea, {
      onEachFeature: function(feature, layer) {
        console.log('add', area, feature, layer)
        self.renderTr(area, feature);
        layer.on('pm:edit', function(e) {
          self.blueprint[area] = e.target.toGeoJSON();
          $('#leaflet-tr-' + area).replaceWith(self.getTr(area, self.blueprint[area]));
        });
      }
    }).addTo(self.map);
  }
};

MapEditor.prototype.renderTr = function (area, feature) {
  $('#leaflet-body').append(this.getTr(area, feature));
};

MapEditor.prototype.getTr = function (area, feature) {
  var link = feature.properties && feature.properties.link || '#';
  return '<tr id="leaflet-tr-' + area + '"> '
    + ' <th id="leaflet-th-' + area + '-type">' + feature.geometry.type +'</th>'
    + ' <th id="leaflet-th-' + area + '-coordinates">' + JSON.stringify(feature.geometry.coordinates[0]) + '</th>'
    + ' <th id="leaflet-th-' + area + '-link"> <input type="text" id="leaflet-feature-link-' + area + '" value="' + link + '"> </th>'
    + '</tr>';
};

MapEditor.prototype.getBlueprint = function () {
  var self = this;
  console.log(self.blueprint)
  Object.keys(self.blueprint).forEach(function(key) {
    self.blueprint[key].properties.link = $('#leaflet-feature-link-' + key).val();
  });
  return self.blueprint;
};

$(function() {

  var $map = $('#map');
  var bar = $('.bar');
  var percent = $('.percent');
  var status = $('#status');
  var $form = $('form');
  var editor;

  if($map.length) {
    editor = new MapEditor($map.data('image'), $map.data('blueprint'));
  }

  $form.ajaxForm({
    url: $form.find('[name=action]').val(),
    beforeSerialize: function() {
      if(editor) {
        $form.find('[name=blueprint]').val(JSON.stringify(editor.getBlueprint()));
      }
    },
    beforeSend: function() {
        status.empty();
        var percentVal = '0%';
        bar.width(percentVal)
        percent.html(percentVal);
    },
    uploadProgress: function(event, position, total, percentComplete) {
        var percentVal = percentComplete + '%';
        bar.width(percentVal)
        percent.html(percentVal);
    },
    success: function() {
        var percentVal = '100%';
        bar.width(percentVal)
        percent.html(percentVal);
        if(!editor) {
          location.reload();
        }
    },
    complete: function(xhr) {
      status.html(xhr.responseText);
    }
  });
});