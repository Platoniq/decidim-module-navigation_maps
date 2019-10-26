# frozen_string_literal: true

module Decidim
  module NavigationMaps
    # A form object used to configure the blueprint content block from the admin panel.
    #
    class BlueprintForm < Decidim::Form
      mimic :blueprint

      attribute :blueprint, Object
      attribute :image
    end
  end
end
