# frozen_string_literal: true

module Decidim
  module NavigationMaps
    module NavigationMapCellHelpers
      include Cell::ViewModel::Partial
        delegate :available_locales, to: :current_organization

        def map_image_url
          organization_blueprints.first&.image&.url
        end

        def blueprints
          organization_blueprints
        end

        private

        def organization_blueprints
          @organization_blueprints ||= OrganizationBlueprints.new(current_organization).query
        end
    end
  end
end
