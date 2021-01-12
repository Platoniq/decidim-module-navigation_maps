# frozen_string_literal: true

module Decidim
  module NavigationMaps
    # Abstract class from which all models in this engine inherit.
    class Blueprint < ApplicationRecord
      self.table_name = "decidim_navigation_maps_blueprints"

      belongs_to :organization, foreign_key: :decidim_organization_id, class_name: "Decidim::Organization"
      has_many :areas,
               foreign_key: "decidim_navigation_maps_blueprint_id",
               class_name: "Decidim::NavigationMaps::BlueprintArea",
               dependent: :destroy

      validates :organization, presence: true
      validates :image,
                file_content_type: { allow: ["image/jpeg", "image/png", "image/svg+xml"] }

      mount_uploader :image, Decidim::NavigationMaps::BlueprintUploader

      def blueprint
        areas.map { |area| [area.area_id.to_s, area.to_geoson] }.to_h
      end
    end
  end
end
