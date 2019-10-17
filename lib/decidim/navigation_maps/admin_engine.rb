# frozen_string_literal: true

module Decidim
  module NavigationMaps
    # This is the engine that runs on the public interface of `NavigationMaps`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::NavigationMaps::Admin

      paths["db/migrate"] = nil
      paths["lib/tasks"] = nil

      routes do
        # Add admin engine routes here
        resources :navigation_maps do
          collection do
            resources :exports, only: [:index, :new, :create]
          end
        end
        root to: "navigation_maps#index"
      end

      initializer "decidim_navigation_maps.admin_assets" do |app|
        app.config.assets.precompile += %w(admin/decidim_navigation_maps_manifest.js admin/decidim_navigation_maps_manifest.css)
      end

      def load_seed
        nil
      end
    end
  end
end
