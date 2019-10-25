# frozen_string_literal: true

require "decidim/core/test/factories"

FactoryBot.define do
  factory :blueprint, class: Decidim::NavigationMaps::Blueprint do
    organization { create(:organization) }
    blueprint { { x: 1, y: 1 } }
    image { Decidim::Dev.test_file("city.jpeg", "image/jpeg") }
  end

  # Add engine factories here
end
