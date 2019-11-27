# frozen_string_literal: true

module Decidim
  module NavigationMaps
    # Abstract class from which all models in this engine inherit.
    class BlueprintArea < ApplicationRecord
      include Decidim::TranslatableAttributes

      self.table_name = "decidim_navigation_maps_blueprint_areas"

      belongs_to :blueprint, foreign_key: :decidim_navigation_maps_blueprint_id, class_name: "Decidim::NavigationMaps::Blueprint"

      validates :blueprint, presence: true

      def to_geoson
        {
          type: area_type,
          geometry: area,
          properties: {
            link: link,
            color: color,
            title: translated_attribute(title),
            description: translated_attribute(description)
          }
        }
      end
    end
  end
end
