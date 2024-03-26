// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// import "jquery-form"; // we use a CDN instead due a bug in webpacker
import NavigationMapEditor from "src/decidim/navigation_maps/admin/map_editor";
import initializeElement from "src/decidim/navigation_maps/tabs_manager";
import { createDialog } from "src/decidim/a11y";

$(() => {
  let $maps = $(".navigation_maps.admin .map");
  let $progress = $(".navigation_maps.admin .progress");
  let $bar = $(".navigation_maps.admin .progress-meter");
  let $loading = $(".navigation_maps.admin .loading");
  let $callout = $(".navigation_maps.admin .callout");
  let $modal = $("#map-edit-modal");
  let dialog = window.Decidim.currentDialogs["map-edit-modal"];
  let $form = $("form");
  let tabs = document.querySelectorAll("#tabs__navigation_maps ul.nav-tabs > li");
  let editors = {};
  let newAreas = {};

  $maps.each((_i, el) => {
    let id = $(el).data("id");
    let table = document.getElementById(`navigation_maps-table-${id}`);
    editors[id] = new NavigationMapEditor(el, table);
    editors[id].onCreateArea((areaId) => {
      newAreas[areaId] = true;
    });

    editors[id].onClickArea((areaId, area) => {
      $modal.find(".modal-content").html("");
      dialog.open();
      $callout.hide();
      $callout.removeClass("alert success");
      // "new" form instead of editing
      let rel = newAreas[areaId]
        ? "new"
        : areaId;
      $modal.find(".modal-content").load(`/admin/navigation_maps/blueprints/${id}/areas/${rel}`, () => {
        let $input1 = $modal.find('input[name="blueprint_area[area_id]"]');
        let $input2 = $modal.find('input[name="blueprint_area[area_type]"]');
        let $input3 = $modal.find('input[name="blueprint_area[area]"]');
        let geoJSON = area.toGeoJSON();
        console.log(geoJSON);
        $modal.removeClass("loading");
        if ($input1.length) { 
          $input1.val(areaId); 
        }
        if ($input2.length) {
          $input2.val(geoJSON.type);
        }
        if ($input3.length) {
          $input3.val(JSON.stringify(geoJSON));
        }
      });
    });
  });

  // Rails AJAX events
  document.body.addEventListener("ajax:error", (responseText) => {
    $callout.contents("p").html(`${responseText.detail[0].message}: <strong>${responseText.detail[0].error}</strong>`);
    $callout.addClass("alert");
  });

  document.body.addEventListener("ajax:success", (responseText) => {
    if (newAreas[responseText.detail[0].area]) {
      // eslint-disable-next-line prefer-reflect
      delete newAreas[responseText.detail[0].area]
    }
    let blueprintId = responseText.detail[0].blueprint_id;
    let areaId = responseText.detail[0].area_id;
    let area = responseText.detail[0].area;
    editors[blueprintId].setLayerProperties(editors[blueprintId].map._layers[areaId], area);
    editors[blueprintId].blueprint[areaId] = area;
    $callout.contents("p").html(responseText.detail[0].message);
    $callout.addClass("success");
  });

  document.body.addEventListener("ajax:complete", () => {
    $callout.show();
    dialog.close();
  })

  for (let idx = 0; idx < tabs.length; idx += 1) {
    tabs[idx].addEventListener("click", function(event) {
      event.preventDefault();
      const anchorReference = event.target;
      const activePaneId = anchorReference.getAttribute("href");
      const activePane = document.querySelector(activePaneId);
      const id = activePane.querySelector(".map")?.dataset?.id;
      if (id) {
        editors[id].reload();
      }
    });
  }

  // If a new item si going to be created o the image is changed a reload is needed
  let needsReload = () => {
    let reload = false;
    if ($form.find("#map-new input:checked").length) {
      return true;
    }
    if ($form.find(".delete-tab input[type=checkbox]:checked").length) {
      return true;
    }

    // eslint-disable-next-line consistent-return
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

window.addEventListener("load", initializeElement("tabs__navigation_maps"));
document.querySelectorAll("[data-dialog]").forEach((component) => createDialog(component))
