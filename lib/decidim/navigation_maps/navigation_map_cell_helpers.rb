# frozen_string_literal: true

module Decidim
  module NavigationMaps
    module NavigationMapCellHelpers
      include Cell::ViewModel::Partial
      delegate :available_locales, to: :current_organization

      def valid_blueprints
        content_block_blueprints.joins(:image_attachment).order(:created_at)
      end

      def valid_blueprints?
        valid_blueprints.any?
      end

      def blueprints
        content_block_blueprints.order(:created_at)
      end

      private

      def content_block_blueprints
        @content_block_blueprints ||= (OrganizationBlueprints.new(current_organization) | ContentBlockBlueprints.new(content_block)).query
      end
    end
  end
end
