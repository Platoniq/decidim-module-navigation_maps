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
        resources :blueprints, only: [:index, :show, :create] do
          resources :areas, param: :area_id
        end
      end

      initializer "decidim_navigation_maps.admin_mount_routes" do
        # Decidim 0.32 wraps its routes in a `scope "/:locale"`. Anything mounted
        # under `/admin` outside that scope is caught by decidim-core's
        # `get "/admin/*rest"` locale redirect, which sends the request to
        # `/:locale/admin/...` where no route matches, so the engine 404s.
        Decidim::Core::Engine.routes do
          extend Decidim::Routes::LocaleRedirects

          scope "/:locale", **locale_scope_options do
            mount Decidim::NavigationMaps::AdminEngine, at: "/admin/navigation_maps", as: "decidim_admin_navigation_maps"
          end
        end
      end

      def load_seed
        nil
      end
    end
  end
end
