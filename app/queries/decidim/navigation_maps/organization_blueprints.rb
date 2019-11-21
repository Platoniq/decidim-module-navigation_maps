# frozen_string_literal: true

module Decidim
  module NavigationMaps
    # This query finds the published blueprints for and organization
    class OrganizationBlueprints < Rectify::Query
      def initialize(organization)
        @organization = organization
      end

      def query
        Decidim::NavigationMaps::Blueprint.where(organization: @organization).order :created_at
      end

      private

      attr_reader :organization
    end
  end
end
