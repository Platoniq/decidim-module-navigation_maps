# frozen_string_literal: true

module Decidim
  module NavigationMaps
    # A form object used to configure the blueprint content block from the admin panel.
    #
    class BlueprintForm < Decidim::Form
      include TranslatableAttributes

      mimic :blueprint

      attribute :blueprint, Object
      attribute :id, Integer
      attribute :decidim_content_block_id, Integer
      attribute :remove, Boolean
      attribute :image
      translatable_attribute :title, String
      translatable_attribute :description, String
      attribute :height, Integer

      # validate :check_image_or_blueprint
      validates :title, translatable_presence: true
      validates :height, numericality: { greater_than: 0 }

      # def check_image_or_blueprint
      #   return if image.present? || blueprint.present?

      #   errors.add(:image, "no image") unless image.present?
      #   errors.add(:blueprint, "no blueprint") unless blueprint.present?
      # end

      def ident
        id || "_"
      end

      def image?
        return unless image && image.respond_to?(:url)
        return image.content_type.start_with? "image" if image.content_type.present?
      end
    end
  end
end
