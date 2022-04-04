# frozen_string_literal: true

require "decidim/gem_manager"

namespace :decidim_navigation_maps do
  namespace :webpacker do
    desc "Installs Decidim Awesome webpacker files in Rails instance application"
    task install: :environment do
      raise "Decidim gem is not installed" if decidim_path.nil?

      install_navigation_maps_npm
    end

    desc "Adds Decidim Awesome dependencies in package.json"
    task upgrade: :environment do
      raise "Decidim gem is not installed" if decidim_path.nil?

      install_navigation_maps_npm
    end

    def install_navigation_maps_npm
      navigation_maps_npm_dependencies.each do |type, packages|
        system! "npm i --save-#{type} #{packages.join(" ")}"
      end
    end

    def navigation_maps_npm_dependencies
      @navigation_maps_npm_dependencies ||= begin
        package_json = JSON.parse(File.read(navigation_maps_path.join("package.json")))

        {
          prod: package_json["dependencies"].map { |package, version| "#{package}@#{version}" },
          dev: package_json["devDependencies"].map { |package, version| "#{package}@#{version}" }
        }.freeze
      end
    end

    def navigation_maps_path
      @navigation_maps_path ||= Pathname.new(navigation_maps_gemspec.full_gem_path) if Gem.loaded_specs.has_key?(gem_name)
    end

    def navigation_maps_gemspec
      @navigation_maps_gemspec ||= Gem.loaded_specs[gem_name]
    end

    def rails_app_path
      @rails_app_path ||= Rails.root
    end

    def system!(command)
      system("cd #{rails_app_path} && #{command}") || abort("\n== Command #{command} failed ==")
    end

    def gem_name
      "decidim-navigation_maps"
    end
  end
end
