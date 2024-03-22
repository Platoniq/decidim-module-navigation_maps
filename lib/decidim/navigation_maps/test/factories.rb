# frozen_string_literal: true

require "decidim/core/test/factories"

FactoryBot.define do
  factory :blueprint, class: "Decidim::NavigationMaps::Blueprint" do
    organization { create(:organization) }
    image { Decidim::Dev.test_file("city.jpeg", "image/jpeg") }
    title { Decidim::Faker::Localized.word }
    description { generate_localized_title }
    content_block { create(:content_block, organization:) }
  end

  factory :blueprint_area, class: "Decidim::NavigationMaps::BlueprintArea" do
    blueprint { create(:blueprint) }
    area do
      {
        "x" => 1,
        "y" => 1
      }
    end
    area_type { "Feature" }
    area_id { "1" }
    link { "#link" }
    link_type { "link" }
    color { "#f00" }
    title { Decidim::Faker::Localized.word }
    description { generate_localized_title }
  end
end
