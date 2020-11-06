# frozen_string_literal: true

module Decidim
  module NavigationMaps
    # This query finds the published blueprints for a content block
    class ContentBlockBlueprints < Rectify::Query
      def initialize(content_block)
        @content_block = content_block
      end

      def query
        Decidim::NavigationMaps::Blueprint.where(content_block: @content_block)
      end

      private

      attr_reader :content_block
    end
  end
end
