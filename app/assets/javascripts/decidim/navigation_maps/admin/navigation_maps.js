// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//= require leaflet
//= require leaflet-geoman.min
//= require jquery.form
//= require_self

function MapEditor(image_path, blueprint) {
  var self = this;
  self.features = {};
  self.blueprint = blueprint || {};
  self.image = new Image();
  self.image.onload = function() {
    self.createMap();
  }
  self.image.src = image_path;
  self.defaultStyle = {
    color: "#2262CC",
    weight: 3,
    opacity: 0.6,
    fillOpacity: 0.1,
    fillColor: "#2262CC"
  };
  self.highlightStyle = {
    color: '#2262CC', 
    weight: 3,
    opacity: 0.6,
    fillOpacity: 0.65,
    fillColor: '#2262CC'
  };
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

  self.map.on('pm:create', function(e) {
    var geojson = e.layer.toGeoJSON();
    self.blueprint[e.layer._leaflet_id] = geojson;
    self.renderTr(e.layer._leaflet_id, geojson);
    e.layer.on('pm:edit', function(e) {
      var area = e.target._leaflet_id;
      self.blueprint[area] = e.target.toGeoJSON();
      $('#leaflet-tr-' + area).replaceWith(self.getTr(area, self.blueprint[area]));
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

    new L.GeoJSON(geoarea, {
      onEachFeature: function(feature, layer) {
        layer._leaflet_id = area;
        self.renderTr(area, feature);
        layer.on('pm:edit', function(e) {
          self.blueprint[area] = e.target.toGeoJSON();
        });
        layer.on('mouseover', function(e) {
          layer.setStyle(self.highlightStyle);
          $('#leaflet-tr-' + layer._leaflet_id).addClass('selected');
        });
        layer.on('mouseout', function(e) {
          layer.setStyle(self.defaultStyle);
          $('#leaflet-tr-' + layer._leaflet_id).removeClass('selected');
        });
      }
    }).addTo(self.map);
  }
};

MapEditor.prototype.renderTr = function (area, feature) {
  var self = this;
  var tr = $('#leaflet-body').append(this.getTr(area, feature))
  $('#leaflet-tr-'+area).mouseover(function() { self.highlightArea(area) });
  $('#leaflet-tr-'+area).mouseout(function() { self.defaultArea(area) });
};

MapEditor.prototype.getTr = function (area, feature) {
  var link = feature.properties && feature.properties.link || '#';
  return '<tr id="leaflet-tr-' + area + '" data-id="' + area + '"> '
    + ' <td id="leaflet-td-' + area + '-id">' + area +'</td>'
    + ' <td id="leaflet-td-' + area + '-type">' + feature.geometry.type +'</td>'
    + ' <td id="leaflet-td-' + area + '-link"> <input type="text" id="leaflet-feature-link-' + area + '" value="' + link + '"> </td>'
    + '</tr>';
};

MapEditor.prototype.getBlueprint = function () {
  var self = this;
  Object.keys(self.blueprint).forEach(function(key) {
    self.blueprint[key].properties.link = $('#leaflet-feature-link-' + key).val();
  });
  return self.blueprint;
};

MapEditor.prototype.highlightArea = function(blueprint) {
  var self = this;
  self.map._layers[blueprint].setStyle(self.highlightStyle);
}

MapEditor.prototype.defaultArea = function(blueprint) {
  var self = this;
  self.map._layers[blueprint].setStyle(self.defaultStyle);
}

$(function() {

  var $map = $('#map');
  var bar = $('.progress-meter');
  var percent = $('.progress-meter');
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
    success: function(responseText, statusText, xhr, $form) {
        var percentVal = '100%';
        bar.width(percentVal)
        percent.html(percentVal);
        if($form.find('input[type=file]').val()) {
          location.reload();
        }
    },
    complete: function(xhr) {
      status.html(xhr.responseText);
    }
  });
});