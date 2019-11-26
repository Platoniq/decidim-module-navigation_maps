// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//= require leaflet
//= require leaflet-geoman.min
//= require jquery.form
//= require decidim/navigation_maps/admin/map_editor
//= require_self

$(function() {

  var $maps = $('.navigation_maps.admin .map');
  var $progress = $('.navigation_maps.admin .progress');
  var $bar = $('.navigation_maps.admin .progress-meter');
  var $loading = $('.navigation_maps.admin .loading');
  var $callout = $('.navigation_maps.admin .callout');
  var $modal = $('#mapEditModal');
  var $form = $('form');
  var $tabs = $('#navigation_maps-tabs');
  var $accordion = $('.navigation_maps.admin .accordion');
  var editors = {};

  $maps.each(function() {
    var id = $(this).data('id');
    var table = document.getElementById("navigation_maps-table-" + id);
    editors[id] = new NavigationMapEditor(this, table);
    editors[id].onClickArea(function(area_id, area, obj) {
      $modal.find('.modal-content').html('');
      $modal.addClass('loading').foundation('open');
      $callout.hide();
      $callout.removeClass('alert success');
      $modal.find('.modal-content').load(`/admin/navigation_maps/blueprints/${id}/areas/${area_id}`, function() {
        $modal.removeClass('loading');
      });
    });
  });

  // Rails AJAX events
  document.body.addEventListener('ajax:error', function(responseText) {
    $callout.contents('p').html(responseText.detail[0].message + ": <strong>" + responseText.detail[0].error + "</strong>");
    $callout.addClass('alert');
  });

  document.body.addEventListener('ajax:success', function(responseText) {
    console.log(responseText);
    $callout.contents('p').html(responseText.detail[0].message);
    $callout.addClass('success');
  });

  document.body.addEventListener('ajax:complete', function(xhr, event) {
    console.log(event, xhr)
    $callout.show();
    $modal.foundation('close');
  })

  $tabs.on('change.zf.tabs', function(e, $tab, $content) {
    var id = $content.find('.map').data('id');
    if(id) {
      editors[id].reload();
    }
  });

  $accordion.on('down.zf.accordion', function(e, $accordion) {
    var id = $accordion.find('.map').data('id');
    if(id) {
      editors[id].reload();
    }
  });

  // If a new item si going to be created o the image is changed a reload is needed
  var needsReload = function() {
    var reload = false;
    if($form.find('#map-new input:checked').length) return true;
    if($form.find('.delete-tab input[type=checkbox]:checked').length) return true;

    $form.find('input[type=file],input[tabs_id=blueprints___title]').each(function() {
      if($(this).val()) {
        reload = true;
        return false;
      }
    });
    return reload;
  };

  $form.ajaxForm({
    url: $form.find('[name=action]').val(),
    beforeSerialize: function() {
      Object.keys(editors).forEach(function(key) {
        var editor = editors[key];
        $(`#blueprints_${editor.id}_blueprint`).val(JSON.stringify(editor.getBlueprint()));
      });
    },
    beforeSend: function() {
        var percentVal = '0%';
        $bar.width(percentVal).html(percentVal);
        $progress.show();
        $callout.hide();
        $callout.removeClass('alert success');
        $loading.show();
    },
    uploadProgress: function(event, position, total, percentComplete) {
        var percentVal = percentComplete + '%';
        $bar.width(percentVal).html(percentVal);
    },
    success: function(responseText, statusText, xhr, $form) {
        $callout.show();
        $progress.hide();
        $callout.contents('p').html(responseText);
        $callout.addClass('success');
        $loading.hide();
        if(needsReload()) {
          $loading.show();
          location.reload();
        }
    },
    error: function(xhr) {
      $loading.hide();
      $callout.show();
      $callout.contents('p').html(xhr.responseText);
      $callout.addClass('alert');
    }
  });
});
