# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/navigation_maps/version"

Gem::Specification.new do |s|
  s.version = Decidim::NavigationMaps::VERSION
  s.authors = ["Ivan Vergés"]
  s.email = ["ivan@platoniq.net"]
  s.license = "AGPL-3.0"
  s.homepage = "https://github.com/decidim/decidim-module-navigation_maps"
  s.required_ruby_version = ">= 2.5"

  s.name = "decidim-navigation_maps"
  s.summary = "A decidim navigation_maps module"
  s.description = "Allows to map processes to image parts using maps."

  s.files = Dir["{app,config,lib}/**/*", "LICENSE-AGPLv3.txt", "Rakefile", "README.md"]

  s.add_dependency "decidim-core", Decidim::NavigationMaps::DECIDIM_VERSION
end
