# frozen_string_literal: true

module Decidim
  module NavigationMaps
    class BlueprintForms < Decidim::Form
      attribute :blueprints, [BlueprintForm]
      attribute :content_block_id, Integer
    end
  end
end
