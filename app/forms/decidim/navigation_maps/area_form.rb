# frozen_string_literal: true

module Decidim
  module NavigationMaps
    # A form object used to configure the blueprint content block from the admin panel.
    #
    class AreaForm < Decidim::Form
      include TranslatableAttributes

      mimic :blueprint_area

      attribute :area, Object
      attribute :area_type, String
      attribute :area_id, String
      attribute :link, String
      attribute :link_type, String
      attribute :no_popup, String
      attribute :color, String
      translatable_attribute :title, String
      translatable_attribute :description, String

      def no_popup
        return link_type == "direct" unless super

        super.to_i.nonzero?
      end

      def color
        return "#2262cc" if super.blank?

        return "##{super}" unless super.match?(/^#/)

        super
      end
    end
  end
end
