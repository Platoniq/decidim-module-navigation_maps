# frozen_string_literal: true

require "decidim/navigation_maps/admin"
require "decidim/navigation_maps/engine"
require "decidim/navigation_maps/admin_engine"

module Decidim
  # This namespace holds the logic of the `NavigationMaps` component. This component
  # allows users to create navigation_maps in a participatory space.
  module NavigationMaps
    autoload :NavigationMapCellHelpers, "decidim/navigation_maps/navigation_map_cell_helpers"
  end
end
