# frozen_string_literal: true

namespace :decidim_navigation_maps do
  desc "custom seeding"
  task seed: :environment do
    Decidim::NavigationMaps::Engine.load_seed
  end
end
