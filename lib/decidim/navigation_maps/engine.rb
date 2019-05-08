# frozen_string_literal: true

require "rails"
require "decidim/core"
require "decidim/navigation_maps/admin/form_builder_helpers"

module Decidim
  module NavigationMaps
    # This is the engine that runs on the public interface of navigation_maps.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::NavigationMaps

      routes do
        # Add engine routes here
        # resources :navigation_maps
        # root to: "navigation_maps#index"
      end

      initializer "decidim_navigation_maps.assets" do |app|
        app.config.assets.precompile += %w[decidim_navigation_maps_manifest.js decidim_navigation_maps_manifest.css]
      end


      initializer "decidim.navigation_maps.content_blocks" do
        # Add custom form_builder method to handle map images uploads
        ActionView::Base.default_form_builder.class_eval do
          include Decidim::NavigationMaps::Admin::FormBuilderHelpers
        end

        Decidim.content_blocks.register(:homepage, :navigation_map) do |content_block|
          content_block.cell = "decidim/content_blocks/navigation_map"
          content_block.public_name_key = "decidim.content_blocks.navigation_map.name"
          content_block.settings_form_cell = "decidim/content_blocks/navigation_map_settings_form"

          content_block.images = [
            {
              name: :map_image,
              uploader: "Decidim::ImageUploader"
            }
          ]
          content_block.settings do |settings|
            settings.attribute :html_content, type: :text, default: "I'm the map"
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
