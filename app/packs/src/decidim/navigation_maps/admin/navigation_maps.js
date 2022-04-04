// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// import "jquery-form"; // we use a CDN instead due a bug in webpacker
import NavigationMapEditor from "src/decidim/navigation_maps/admin/map_editor.js";

$(() => {

  let $maps = $(".navigation_maps.admin .map");
  let $progress = $(".navigation_maps.admin .progress");
  let $bar = $(".navigation_maps.admin .progress-meter");
  let $loading = $(".navigation_maps.admin .loading");
  let $callout = $(".navigation_maps.admin .callout");
  let $modal = $("#mapEditModal");
  let $form = $("form");
  let $tabs = $("#navigation_maps-tabs");
  let $accordion = $(".navigation_maps.admin .accordion");
  let editors = {};
  let new_areas = {};

  $maps.each((_i, el) => {
    let id = $(el).data("id");
    let table = document.getElementById(`navigation_maps-table-${id}`);
    editors[id] = new NavigationMapEditor(el, table);
    editors[id].onCreateArea((area_id) => {
      new_areas[area_id] = true;
    });

    editors[id].onClickArea((area_id, area) => {
      $modal.find(".modal-content").html("");
      $modal.addClass("loading").foundation("open");
      $callout.hide();
      $callout.removeClass("alert success");
      // "new" form insted of editing
      let rel = new_areas[area_id]
        ? "new"
        : area_id;
      $modal.find(".modal-content").load(`/admin/navigation_maps/blueprints/${id}/areas/${rel}`, () => {
        let $input1 = $modal.find('input[name="blueprint_area[area_id]"]');
        let $input2 = $modal.find('input[name="blueprint_area[area_type]"]');
        let $input3 = $modal.find('input[name="blueprint_area[area]"]');
        let a = area.toGeoJSON();
        $modal.removeClass("loading");
        if ($input1.length) { 
          $input1.val(area_id); 
        }
        if ($input2.length) {
          $input2.val(a.type);
        }
        if ($input3.length) {
          $input3.val(JSON.stringify(a));
        }
        $modal.find("ul[data-tabs=true]").each(() => {
          new Foundation.Tabs($(el)); // eslint-disable-line
        });
      });
    });
  });

  // Rails AJAX events
  document.body.addEventListener("ajax:error", (responseText) => {
    $callout.contents("p").html(`${responseText.detail[0].message}: <strong>${responseText.detail[0].error}</strong>`);
    $callout.addClass("alert");
  });

  document.body.addEventListener("ajax:success", (responseText) => {
    if (new_areas[responseText.detail[0].area]) {
      delete new_areas[responseText.detail[0].area]
    }
    let blueprint_id = responseText.detail[0].blueprint_id;
    let area_id = responseText.detail[0].area_id;
    let area = responseText.detail[0].area;
    editors[blueprint_id].setLayerProperties(editors[blueprint_id].map._layers[area_id], area);
    editors[blueprint_id].blueprint[area_id] = area;
    $callout.contents("p").html(responseText.detail[0].message);
    $callout.addClass("success");
  });

  document.body.addEventListener("ajax:complete", () => {
    $callout.show();
    $modal.foundation("close");
  })

  $tabs.on("change.zf.tabs", (e, $tab, $content) => {
    let id = $content.find(".map").data("id");
    if (id) {
      editors[id].reload();
    }
  });

  $accordion.on("down.zf.accordion", () => {
    let id = $accordion.find(".map").data("id");
    if (id) {
      editors[id].reload();
    }
  });

  // If a new item si going to be created o the image is changed a reload is needed
  let needsReload = () => {
    let reload = false;
    if ($form.find("#map-new input:checked").length) {
      return true;
    }
    if ($form.find(".delete-tab input[type=checkbox]:checked").length) {
      return true;
    }

    $form.find("input[type=file],input[tabs_id=blueprints___title]").each((_i, el) => {
      if ($(el).val()) {
        reload = true;
        return false;
      }
    });
    return reload;
  };

  $form.ajaxForm({
    url: $form.find("[name=action]").val(),
    beforeSerialize: () => {
      Object.keys(editors).forEach((key) => {
        let editor = editors[key];
        $(`#blueprints_${editor.id}_blueprint`).val(JSON.stringify(editor.getBlueprint()));
      });
    },
    beforeSend: () => {
      let percentVal = "0%";
      $bar.width(percentVal).html(percentVal);
      $progress.show();
      $callout.hide();
      $callout.removeClass("alert success");
      $loading.show();
    },
    uploadProgress: (event, position, total, percentComplete) => { // eslint-disable-line
      let percentVal = `${percentComplete}%`;
      $bar.width(percentVal).html(percentVal);
    },
    success: (responseText) => {
      $callout.show();
      $progress.hide();
      $callout.contents("p").html(responseText);
      $callout.addClass("success");
      $loading.hide();
      if (needsReload()) {
        $loading.show();
        location.reload();
      }
    },
    error: (xhr) => {
      $loading.hide();
      $callout.show();
      $callout.contents("p").html(xhr.responseText);
      $callout.addClass("alert");
    }
  });
});
