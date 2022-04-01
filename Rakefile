# frozen_string_literal: true

require "decidim/dev/common_rake"

def install_module(path)
  Dir.chdir(path) do
    system("bundle exec rake decidim_navigation_maps:install:migrations")
    system("bundle exec rake db:migrate")
  end
end

def override_webpacker_config_files(path)
  Dir.chdir(path) do
    system("bundle exec rake decidim_navigation_maps:webpacker:install")
  end
end

def seed_db(path)
  Dir.chdir(path) do
    system("bundle exec rake db:seed")
  end
end

def seed_module_db(path)
  Dir.chdir(path) do
    system("bundle exec rake decidim_navigation_maps:seed")
  end
end

desc "Generates a dummy app for testing"
task test_app: "decidim:generate_external_test_app" do
  ENV["RAILS_ENV"] = "test"
  install_module("spec/decidim_dummy_app")
  override_webpacker_config_files("spec/decidim_dummy_app")
end

desc "Generates a development app"
task :development_app do
  Bundler.with_original_env do
    generate_decidim_app(
      "development_app",
      "--app_name",
      "#{base_app_name}_development_app",
      "--path",
      "..",
      "--recreate_db",
      "--demo"
    )
  end

  install_module("development_app")
  override_webpacker_config_files("development_app")
  ENV["SKIP_MODULE_SEEDS"] = "1"
  seed_db("development_app")
  # manually seed navigation maps to ensure participatory process groups are created
  ENV.delete "SKIP_MODULE_SEEDS"
  seed_module_db("development_app")
end
