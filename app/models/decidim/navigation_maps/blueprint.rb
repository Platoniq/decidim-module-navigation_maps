# frozen_string_literal: true

module Decidim
    module NavigationMaps
      # Abstract class from which all models in this engine inherit.
      class Blueprint < ApplicationRecord
        self.table_name = "decidim_navigation_maps_blueprints"
        belongs_to :organization, foreign_key: :decidim_organization_id, class_name: "Decidim::Organization"

        validates :blueprint, presence: true
      end
    end
  end
  
