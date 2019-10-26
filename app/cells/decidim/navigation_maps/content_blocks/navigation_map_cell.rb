# frozen_string_literal: true

module Decidim
  module NavigationMaps
    module ContentBlocks
      class NavigationMapCell < Decidim::ViewModel
        def show
          render if map_image_url
        end

        def map_image_url
          organization_blueprints.first&.image&.url
        end

        def blueprint_data
          organization_blueprints.first&.blueprint
        end

        private

        def organization_blueprints
          @organization_blueprints ||= OrganizationBlueprints.new(current_organization).query
        end
      end
    end
  end
end
