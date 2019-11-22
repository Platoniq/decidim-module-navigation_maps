// Creates a map

function MapEditor(map_object, table_object) {
  var self = this;
  self.features = {};
  self.map_object = map_object;
  self.table_object = table_object;
  self.id = map_object.dataset.id;
  self.image_path = map_object.dataset.image;
  self.blueprint = map_object.dataset.blueprint;
  self.blueprint = self.blueprint ? JSON.parse(self.blueprint) : {};
  self.image = new Image();
  self.image.onload = function() {
    self.createMap();
  }
  self.image.src = self.image_path;
}

MapEditor.prototype.createMap = function() {
  var self = this;
  self.map = L.map(self.map_object, {
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
    self.renderRow(e.layer, geojson);
  });

  self.map.on('pm:remove', function(e) {
    delete self.blueprint[e.layer._leaflet_id];
    document.getElementById(self.rowId(e.layer._leaflet_id)).remove();
  });

};

MapEditor.prototype.createAreas = function() {
  var self = this;
  for (area in self.blueprint) {
    var geoarea = self.blueprint[area];
    // avoid non-polygons for the moment
    if(!geoarea.geometry || geoarea.geometry.type !== 'Polygon') continue;

    new L.GeoJSON(geoarea, {
      onEachFeature: function(feature, layer) {
        layer._leaflet_id = area;
        self.renderRow(layer, feature);
      }
    }).addTo(self.map);
  }
};

MapEditor.prototype.renderRow = function (layer, feature) {
  var self = this;
  var tbody = self.table_object.getElementsByTagName('tbody')[0];
  var tr = this.rowTemplate(layer._leaflet_id, feature);

  layer.on('mouseover', function(e) {
    e.target.getElement().classList.add('selected')
    document.getElementById(self.rowId(e.target._leaflet_id)).classList.add('selected');
  });

  layer.on('mouseout', function(e) {
    e.target.getElement().classList.remove('selected')
    document.getElementById(self.rowId(e.target._leaflet_id)).classList.remove('selected');
  });

  tr.addEventListener("mouseover", function() {
    layer.getElement().classList.add('selected')
  });

  tr.addEventListener("mouseout", function() {
    layer.getElement().classList.remove('selected')
  });

  layer.on('pm:edit', function(e) {
    self.blueprint[e.target._leaflet_id] = e.target._leaflet_id;
    // var tr = document.getElementById(self.rowId(e.target._leaflet_id));
    // tr.parentNode.replaceChild(self.rowTemplate(e.target._leaflet_id, self.blueprint[e.target._leaflet_id]), tr);
  });

  tbody.appendChild(tr);
};

MapEditor.prototype.removeRow = function (area, feature) {

};

MapEditor.prototype.rowTemplate = function (area, feature) {
  var link = feature.properties && feature.properties.link || '#';
  var tr = document.createElement('tr');
  tr.id = this.rowId(area);
  tr.innerHTML = ' <td>' + area +'</td>'
               + ' <td><input type="text" id="' + tr.id + '-link" value="' + link + '"></td>';
  return tr;
};

MapEditor.prototype.rowId = function (id) {
  return `map-editor-${this.id}-tr-${id}`;
};

MapEditor.prototype.getBlueprint = function () {
  var self = this;
  Object.keys(self.blueprint).forEach(function(key) {
    var link = document.getElementById(self.rowId(key) + "-link");
    self.blueprint[key].properties = self.blueprint[key] && self.blueprint[key].properties || {link: '#'}
    if(link) self.blueprint[key].properties.link = link.value;
  });
  return self.blueprint;
};

MapEditor.prototype.reload = function () {
  this.map.invalidateSize(true);
}
