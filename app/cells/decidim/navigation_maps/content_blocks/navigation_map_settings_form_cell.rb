# frozen_string_literal: true

module Decidim
  module NavigationMaps
    module ContentBlocks
      class NavigationMapSettingsFormCell < Decidim::ViewModel
        include NavigationMaps::NavigationMapCellHelpers
        alias form model

        view_paths << "#{Decidim::NavigationMaps::Engine.root}/app/cells/decidim/navigation_maps/content_blocks/navigation_map_settings_form"

        def blueprint_form(blueprint = nil)
          blueprint ||= Blueprint.new(content_block:)
          BlueprintForm.from_model(blueprint).with_context(organization: current_organization)
        end

        # it should come from the Engine Routes
        def blueprints_path
          "/admin/navigation_maps/blueprints"
        end

        def content_block
          options[:content_block]
        end

        def label
          I18n.t("decidim.content_blocks.html.html_content")
        end

        def image?(frm)
          frm.image.present?
        end

        def image_path(image, options = {})
          options.merge!({ only_path: true })
          Rails.application.routes.url_helpers.rails_blob_url(image, options)
        end
      end
    end
  end
end
