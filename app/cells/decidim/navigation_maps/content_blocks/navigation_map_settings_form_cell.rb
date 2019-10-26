# frozen_string_literal: true

module Decidim
  module NavigationMaps
    module ContentBlocks
      class NavigationMapSettingsFormCell < NavigationMapCell
        # Custom form for this Cell
        def form
          blueprint = organization_blueprints.first
          form = if blueprint
                   BlueprintForm.from_model(blueprint)
                 else
                   BlueprintForm.new
                 end
          form.with_context(organization: current_organization)
        end

        # it should come from the Engine Routes
        def blueprints_path
          "/admin/navigation_maps/blueprints"
        end
      end
    end
  end
end
