# frozen_string_literal: true

require "rails"
require "decidim/core"

module Decidim
  module NavigationMaps
    # This is the engine that runs on the public interface of navigation_maps.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::NavigationMaps

      initializer "decidim_navigation_maps.assets" do |app|
        app.config.assets.precompile += %w(decidim_navigation_maps_manifest.js decidim_navigation_maps_manifest.css)
      end

      initializer "decidim.navigation_maps.content_blocks" do
        Decidim.content_blocks.register(:homepage, :navigation_map) do |content_block|
          content_block.cell = "decidim/navigation_maps/content_blocks/navigation_map"
          content_block.public_name_key = "decidim.navigation_maps.content_blocks.name"
          content_block.settings_form_cell = "decidim/navigation_maps/content_blocks/navigation_map_settings_form"

          content_block.settings do |settings|
            settings.attribute :title, type: :text, translated: true
          end
        end

        Decidim.content_blocks.register(:participatory_process_group_homepage, :navigation_map) do |content_block|
          content_block.cell = "decidim/navigation_maps/content_blocks/navigation_map"
          content_block.public_name_key = "decidim.navigation_maps.content_blocks.name"
          content_block.settings_form_cell = "decidim/navigation_maps/content_blocks/navigation_map_settings_form"

          content_block.settings do |settings|
            settings.attribute :title, type: :text, translated: true
          end
        end
      end

      initializer "decidim.navigation_maps.add_cells_view_paths" do
        Cell::ViewModel.view_paths << File.expand_path("#{Decidim::NavigationMaps::Engine.root}/app/cells")
        Cell::ViewModel.view_paths << File.expand_path("#{Decidim::NavigationMaps::Engine.root}/app/views") # for partials
      end
    end
  end
end
