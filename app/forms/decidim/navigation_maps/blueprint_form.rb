# frozen_string_literal: true

module Decidim
  module NavigationMaps
    # A form object used to configure the blueprint content block from the admin panel.
    #
    class BlueprintForm < Decidim::Form
      mimic :blueprint

      attribute :blueprint, Object
      attribute :image
      attribute :title
      attribute :description

      def image?
        return unless image && image.respond_to?(:url)
        return image.content_type.start_with? "image" if image.content_type.present?
      end
    end
  end
end
