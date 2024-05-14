# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/navigation_maps/version"

Gem::Specification.new do |s|
  s.version = Decidim::NavigationMaps::VERSION
  s.authors = ["Ivan Vergés"]
  s.email = ["ivan@platoniq.net"]
  s.license = "AGPL-3.0"
  s.homepage = "https://github.com/Platoniq/decidim-module-navigation_maps"
  s.required_ruby_version = ">= 3.1"

  s.name = "decidim-navigation_maps"
  s.summary = "A decidim navigation_maps module"
  s.description = "Allows to create visual guiding maps in content blocks for Decidim."

  s.files = Dir["{app,config,lib,db}/**/*", "LICENSE-AGPLv3.txt", "Rakefile", "package.json", "README.md"]

  s.add_dependency "decidim-admin", Decidim::NavigationMaps::DECIDIM_VERSION
  s.add_dependency "decidim-core", Decidim::NavigationMaps::DECIDIM_VERSION

  s.add_development_dependency "decidim-dev", Decidim::NavigationMaps::DECIDIM_VERSION
  s.metadata["rubygems_mfa_required"] = "true"
end
