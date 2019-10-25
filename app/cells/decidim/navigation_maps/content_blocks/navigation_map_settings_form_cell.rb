# frozen_string_literal: true

module Decidim
  module NavigationMaps
    module ContentBlocks
      class NavigationMapSettingsFormCell < Decidim::ViewModel
        alias form model

        def map_image_url
          model.images_container.map_image.url
        end

        def label
          I18n.t("decidim.content_blocks.html.html_content")
        end

        def blueprint_data
          organization_blueprints.first&.blueprint&.to_json&.html_safe
        end

        private

        def organization_blueprints
          @organization_blueprints ||= OrganizationBlueprints.new(current_organization).query
        end
      end
    end
  end
end
