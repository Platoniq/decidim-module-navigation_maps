# frozen_string_literal: true

module Decidim
  module NavigationMaps
    module ContentBlocks
      class GroupsNavigationMapCell < NavigationMapCell
        def section_classes
          "section"
        end

        def wrapper_classes
          nil
        end

        def row_classes
          "row column"
        end
      end
    end
  end
end
