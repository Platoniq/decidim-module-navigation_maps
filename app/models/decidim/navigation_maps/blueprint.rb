# frozen_string_literal: true

module Decidim
  module NavigationMaps
    # Abstract class from which all models in this engine inherit.
    class Blueprint < ApplicationRecord
      include Decidim::HasUploadValidations

      self.table_name = "decidim_navigation_maps_blueprints"

      attribute :height, :integer, default: 475

      belongs_to :organization, foreign_key: :decidim_organization_id, class_name: "Decidim::Organization"
      belongs_to :content_block, foreign_key: :decidim_content_block_id, class_name: "Decidim::ContentBlock"
      has_many :areas,
               foreign_key: "decidim_navigation_maps_blueprint_id",
               class_name: "Decidim::NavigationMaps::BlueprintArea",
               dependent: :destroy

      validates :height, numericality: { greater_than: 0 }

      has_one_attached :image
      validates_upload :image, uploader: Decidim::NavigationMaps::BlueprintUploader

      def blueprint
        areas.to_h { |area| [area.area_id.to_s, area.to_geoson] }
      end
    end
  end
end
