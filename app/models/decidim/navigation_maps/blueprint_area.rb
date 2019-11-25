# frozen_string_literal: true

module Decidim
  module NavigationMaps
    # Abstract class from which all models in this engine inherit.
    class BlueprintArea < ApplicationRecord
      self.table_name = "decidim_navigation_maps_blueprint_areas"

      belongs_to :blueprint, foreign_key: :decidim_navigation_maps_blueprint_id, class_name: "Decidim::NavigationMaps::Blueprint"

      validates :blueprint, presence: true
    end
  end
end
