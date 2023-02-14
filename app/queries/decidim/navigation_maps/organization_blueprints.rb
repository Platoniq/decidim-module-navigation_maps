# frozen_string_literal: true

module Decidim
  module NavigationMaps
    # This query finds the published blueprints for and organization
    class OrganizationBlueprints < Decidim::Query
      def initialize(organization)
        @organization = organization
      end

      def query
        Decidim::NavigationMaps::Blueprint.where(organization: @organization)
      end

      private

      attr_reader :organization
    end
  end
end
