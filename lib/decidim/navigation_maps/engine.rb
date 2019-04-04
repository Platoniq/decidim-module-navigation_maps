# frozen_string_literal: true

require "rails"
require "decidim/core"

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
        Decidim.content_blocks.register(:homepage, :navigation_map) do |content_block|
          content_block.cell = "decidim/content_blocks/navigation_map"
          content_block.public_name_key = "decidim.content_blocks.navigation_map.name"
        end
        ActiveSupport::Notifications.subscribe "start_processing.action_controller" do |_name, _started, _finished, _unique_id, data|
          unless block_exists 'navigation_map_2'.to_sym
            # Register addional blocks
            Decidim.content_blocks.register(:homepage, :navigation_map_2) do |content_block|
              content_block.cell = "decidim/content_blocks/navigation_map"
              content_block.public_name_key = "decidim.content_blocks.navigation_map.name"
            end
          end
        end
      end

      private

      def block_exists(name)
        Decidim.content_blocks.all["homepage"].any? { |content_block| content_block.name == name }
      end
    end
  end
end
