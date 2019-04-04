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

      def load_seed
        nil
      end
    end
  end
end
