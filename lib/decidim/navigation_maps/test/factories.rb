# frozen_string_literal: true

require "decidim/core/test/factories"

FactoryBot.define do
  factory :blueprint, class: Decidim::NavigationMaps::Blueprint do
    organization { create(:organization) }
    image { Decidim::Dev.test_file("city.jpeg", "image/jpeg") }
    title { Decidim::Faker::Localized.word }
    description { generate_localized_title }
  end

  factory :blueprint_area, class: Decidim::NavigationMaps::BlueprintArea do
    blueprint { create(:blueprint) }
    area { { x: 1, y: 1 } }
    area_type { "Feature" }
    url { "#" }
    title { Decidim::Faker::Localized.word }
    description { generate_localized_title }
  end
end
