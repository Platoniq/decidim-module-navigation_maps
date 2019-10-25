# frozen_string_literal: true

require "decidim/core/test/factories"

FactoryBot.define do
  factory :blueprint, class: Decidim::NavigationMaps::Blueprint do
    organization { create(:organization) }
    blueprint { {x: 1} }
  end

  # Add engine factories here
end
