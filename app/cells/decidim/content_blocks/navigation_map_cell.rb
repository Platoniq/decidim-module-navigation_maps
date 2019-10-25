# frozen_string_literal: true

module Decidim
  module ContentBlocks
    class NavigationMapCell < Decidim::ViewModel
      def show       
    		render
      end

      def html_content
        model.settings.html_content.html_safe
      end

      def map_image_url
        model.images_container.map_image.url
      end 

      def blueprint_data
        Decidim::NavigationMaps::Blueprint.first.blueprint.to_json.html_safe
      end
    end
  end
end
