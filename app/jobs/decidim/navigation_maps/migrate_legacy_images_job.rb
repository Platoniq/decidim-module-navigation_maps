# frozen_string_literal: true

module Decidim
  module NavigationMaps
    class MigrateLegacyImagesJob < ApplicationJob
      queue_as :default

      def perform(organization_id, mappings = [], logger = Rails.logger)
        @organization_id = organization_id
        @routes_mappings = mappings
        @logger = logger

        migrate_all!
      end

      private

      attr_reader :routes_mappings, :logger

      def migrate_all!
        Decidim::CarrierWaveMigratorService.migrate_attachment!(
          klass: Decidim::NavigationMaps::Blueprint,
          cw_attribute: "image",
          cw_uploader: Decidim::NavigationMaps::Cw::BlueprintUploader,
          as_attribute: "image",
          logger: @logger,
          routes_mappings:
        )
      end
    end
  end
end
