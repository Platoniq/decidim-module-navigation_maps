# frozen_string_literal: true

module Decidim
  module NavigationMaps
    module ContentBlocks
      class NavigationMapCell < Decidim::ViewModel
        include NavigationMaps::NavigationMapCellHelpers

        self.view_paths << "#{Decidim::NavigationMaps::Engine.root}/app/cells/decidim/navigation_maps/content_blocks/navigation_map"

        def show
          render if map_image_url
        end
      end
    end
  end
end
