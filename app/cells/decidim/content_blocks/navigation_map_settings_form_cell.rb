# frozen_string_literal: true

module Decidim
  module ContentBlocks
    class NavigationMapSettingsFormCell < Decidim::ViewModel

      alias form model

      def content_block
        options[:content_block]
      end

      def map_image_url
        model.images_container.map_image.url
      end 

      def label
        I18n.t("decidim.content_blocks.html.html_content")
      end

      def blueprint_data
        Decidim::NavigationMaps::Blueprint.first.blueprint.to_json.html_safe
      end
    end
  end
end
