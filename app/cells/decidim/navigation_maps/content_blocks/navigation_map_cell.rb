# frozen_string_literal: true

module Decidim
  module NavigationMaps
    module ContentBlocks
      class NavigationMapCell < Decidim::ViewModel
        include NavigationMaps::NavigationMapCellHelpers
        include Decidim::SanitizeHelper

        alias content_block model

        view_paths << "#{Decidim::NavigationMaps::Engine.root}/app/cells/decidim/navigation_maps/content_blocks/navigation_map"

        def show
          render if valid_blueprints?
        end

        def tabs
          render partial: "tabs", locals: { tabs: valid_blueprints }
        end

        def translated_title
          translated_attribute(model.settings.title)
        end

        def autohide_tabs?
          model.settings.autohide_tabs? && valid_blueprints.count < 2
        end

        def image_path(image, options = {})
          options.merge!({ only_path: true })
          Rails.application.routes.url_helpers.rails_blob_url(image, options)
        end
      end
    end
  end
end
