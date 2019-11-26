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
                file_size: { less_than_or_equal_to: ->(_record) { Decidim.maximum_attachment_size } },
                file_content_type: { allow: ["image/jpeg", "image/png", "image/svg+xml"] }

      mount_uploader :image, Decidim::NavigationMaps::BlueprintUploader

      def blueprint
        areas.map do |area|
          [area.id.to_s, {
            type: area.area_type,
            geometry: area.area
          }]
        end.to_h
      end
    end
  end
end
