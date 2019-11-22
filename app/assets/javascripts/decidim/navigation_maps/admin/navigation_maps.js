// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//= require leaflet
//= require leaflet-geoman.min
//= require jquery.form
//= require decidim/navigation_maps/admin/map_editor
//= require_self

$(function() {

  var $maps = $('.navigation_maps.map');
  var bar = $('.progress-meter');
  var percent = $('.progress-meter');
  var status = $('#status');
  var $form = $('form');
  var editors = [];

  $maps.each(function() {
    var table = document.getElementById("navigation_maps-table-" + $(this).data('id'));
    editors.push(new MapEditor(this, table));
  });
  // if($map.length) {
    // editor = new MapEditor($map.data('image'), $map.data('blueprint'));
  // }

  $form.ajaxForm({
    url: $form.find('[name=action]').val(),
    beforeSerialize: function() {
      editors.forEach(function(editor) {
        console.log(editor, `#blueprints_${editor.id}_blueprint` );
        $(`#blueprints_${editor.id}_blueprint`).val(JSON.stringify(editor.getBlueprint()));
      });
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
        // if($form.find('input[type=file]').val()) {
          // location.reload();
        // }
    },
    complete: function(xhr) {
      status.html(xhr.responseText);
    }
  });
});