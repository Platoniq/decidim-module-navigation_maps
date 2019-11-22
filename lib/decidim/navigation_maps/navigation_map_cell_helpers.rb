# frozen_string_literal: true

module Decidim
  module NavigationMaps
    module NavigationMapCellHelpers
      include Cell::ViewModel::Partial
        delegate :available_locales, to: :current_organization

        def valid_blueprints
          organization_blueprints.where.not(image: [nil, '']).order(:created_at)
        end

        def valid_blueprints?
          valid_blueprints.any?
        end

        def blueprints
          organization_blueprints.order(:created_at)
        end

        private

        def organization_blueprints
          @organization_blueprints ||= OrganizationBlueprints.new(current_organization).query
        end
    end
  end
end
