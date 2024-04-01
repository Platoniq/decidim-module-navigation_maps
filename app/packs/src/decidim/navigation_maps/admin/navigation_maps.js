// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// import "jquery-form"; // we use a CDN instead due a bug in webpacker
import NavigationMapEditor from "src/decidim/navigation_maps/admin/map_editor";
import { createDialog } from "src/decidim/a11y";

document.addEventListener("DOMContentLoaded", () => {
  const callout = document.querySelector(".navigation_maps.admin .callout");
  const modal = document.getElementById("map-edit-modal");
  const dialog = window.Decidim.currentDialogs["map-edit-modal"];
  const tabs = document.getElementById("navigation_maps-tabs");
  const editors = {};
  const newAreas = {};
  const $form = $("form");

  document.querySelectorAll(".navigation_maps .map").forEach((element) => {
    const id = element.dataset.id;
    const table = document.getElementById(`navigation_maps-table-${id}`);
    editors[id] = new NavigationMapEditor(element, table);
    editors[id].onCreateArea((areaId) => {
      newAreas[areaId] = true;
    });

    editors[id].onClickArea((areaId, area) => {
      const modalContent = modal.querySelector(".modal-content");
      modal.querySelector(".modal-content").innerHTML = "";
      dialog.open();
      callout.style.display = "none";
      callout.classList.remove("alert", "success");
      const rel = newAreas[areaId]
        ? "new"
        : areaId;

      fetch(`/admin/navigation_maps/blueprints/${id}/areas/${rel}`).
        then((response) => response.text()).
        then((data) => {
          modalContent.innerHTML = data;

          const areaIdInput = modal.querySelector('input[name="blueprint_area[area_id]"]');
          const areaTypeInput = modal.querySelector('input[name="blueprint_area[area_type]"]');
          const areaInput = modal.querySelector('input[name="blueprint_area[area]"]');
          const geoJSON = area.toGeoJSON();
          if (areaIdInput) {
            areaIdInput.value = areaId;
          }
          if (areaTypeInput) {
            areaTypeInput.value = geoJSON.type;
          }
          if (areaInput) {
            areaInput.value = JSON.stringify(geoJSON);
          }

          $(modal).foundation();
        });
    });
  });

  $(tabs).on("change.zf.tabs", (_event, _tab, $content) => {
    const id = $content.find(".map").data("id");
    if (id) {
      editors[id].reload();
    }
  });

  // Rails AJAX events
  document.body.addEventListener("ajax:error", (responseText) => {
    callout.innerHTML = `${responseText.detail[0].message}: <strong>${responseText.detail[0].error}</strong>`;
    callout.classList.add("alert");
  });

  document.body.addEventListener("ajax:success", (responseText) => {
    if (newAreas[responseText.detail[0].area_id]) {
      newAreas[responseText.detail[0].area_id] = false;
    }
    const blueprintId = responseText.detail[0].blueprint_id;
    const areaId = responseText.detail[0].area_id;
    const area = responseText.detail[0].area;
    editors[blueprintId].setLayerProperties(editors[blueprintId].map._layers[areaId], area);
    editors[blueprintId].blueprint[areaId] = area;
    callout.innerHTML = responseText.detail[0].message;
    callout.classList.add("success");
  });

  document.body.addEventListener("ajax:complete", () => {
    callout.style.display = "block";
    dialog.close();
  })

  // If a new item is going to be created o the image is changed a reload is needed
  const needsReload = () => {
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
        const editor = editors[key];
        $(`#blueprints_${editor.id}_blueprint`).val(JSON.stringify(editor.getBlueprint()));
      });
    },
    beforeSend: () => {
      callout.style.display = "none";
      callout.classList.remove("alert", "success");
    },
    success: (responseText) => {
      callout.style.display = "block";
      callout.innerHTML = responseText;
      callout.classList.add("success");
      if (needsReload()) {
        location.reload();
      }
    },
    error: (xhr) => {
      callout.style.display = "block";
      callout.innerHTML = xhr.responseText;
      callout.classList.add("alert");
    }
  });
});

$(".admin.navigation_maps").foundation();

document.querySelectorAll("[data-dialog]").forEach((component) => createDialog(component))
