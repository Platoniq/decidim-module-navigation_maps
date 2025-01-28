# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION
DECIDIM_VERSION = "0.29.1"

gem "decidim", DECIDIM_VERSION

gem "decidim-navigation_maps", path: "."

gem "bootsnap", "~> 1.4"

gem "puma", ">= 6.3.1"

gem "faker"

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri
  gem "decidim-dev", DECIDIM_VERSION
end

group :development do
  gem "letter_opener_web", "~> 1.3"
  gem "listen", "~> 3.1"
  gem "rubocop-faker"
  gem "web-console", "~> 4.2"
end

group :test do
  gem "coveralls_reborn", require: false
end
