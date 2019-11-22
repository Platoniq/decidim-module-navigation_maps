// Creates a map
//= require decidim/navigation_maps/map_view

function NavigationMapEditor(map_object, table_object) {
  var self = this;
  // Call constructor of superclass to initialize superclass-derived members.
  NavigationMapView.call(self, map_object, function() {
    self.createControls();
    if(self.blueprint) {
      self.createAreas();
    };
  });
  self.table_object = table_object;
}

// NavigationMapEditor derives from NavigationMapView
NavigationMapEditor.prototype = Object.create(NavigationMapView.prototype);
NavigationMapEditor.prototype.constructor = NavigationMapEditor;

NavigationMapEditor.prototype.createControls = function() {
  var self = this;
  self.map.pm.addControls({
    position: 'topleft',
    drawCircle: false,
    drawMarker: false,
    drawCircleMarker: false,
    drawPolyline: false,
    cutPolygon: false
  });

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

NavigationMapView.prototype.createAreas = function() {
  var self = this;
  self.forEachBlueprint(function(id, geoarea) {
    new L.GeoJSON(geoarea, {
      onEachFeature: function(feature, layer) {
        layer._leaflet_id = id;
        layer.on('mouseover', function(e) {
          e.target.getElement().classList.add('selected')
          document.getElementById(self.rowId(e.target._leaflet_id)).classList.add('selected');
        });

        layer.on('mouseout', function(e) {
          e.target.getElement().classList.remove('selected')
          document.getElementById(self.rowId(e.target._leaflet_id)).classList.remove('selected');
        });

        layer.on('pm:edit', function(e) {
          self.blueprint[e.target._leaflet_id] = e.target.toGeoJSON();
        });

        self.renderRow(layer, feature);
      }
    }).addTo(self.map);
  });
};

NavigationMapEditor.prototype.renderRow = function (layer, feature) {
  var self = this;
  var tbody = self.table_object.getElementsByTagName('tbody')[0];
  var tr = this.rowTemplate(layer._leaflet_id, feature);

  tr.addEventListener("mouseover", function() {
    layer.getElement().classList.add('selected')
  });

  tr.addEventListener("mouseout", function() {
    layer.getElement().classList.remove('selected')
  });

  tbody.appendChild(tr);
};

NavigationMapEditor.prototype.rowTemplate = function (area, feature) {
  var link = feature.properties && feature.properties.link || '#';
  var tr = document.createElement('tr');
  tr.id = this.rowId(area);
  tr.innerHTML = ' <td>' + area +'</td>'
               + ' <td><input type="text" id="' + tr.id + '-link" value="' + link + '"></td>';
  return tr;
};

NavigationMapEditor.prototype.rowId = function (id) {
  return `map-editor-${this.id}-tr-${id}`;
};

NavigationMapEditor.prototype.getBlueprint = function () {
  var self = this;
  self.forEachBlueprint(function(id, geoarea) {
    var link = document.getElementById(self.rowId(id) + "-link");
    geoarea.properties = geoarea && geoarea.properties || {link: '#'}
    if(link) geoarea.properties.link = link.value;
  });
  return self.blueprint;
};
