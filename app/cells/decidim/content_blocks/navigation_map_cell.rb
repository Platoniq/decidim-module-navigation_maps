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
    end
  end
end
