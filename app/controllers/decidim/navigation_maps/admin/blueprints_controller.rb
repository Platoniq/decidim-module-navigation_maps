# frozen_string_literal: true

module Decidim
  module NavigationMaps
    module Admin
      class BlueprintsController < ::Decidim::NavigationMaps::Admin::ApplicationController
        before_action do
          enforce_permission_to :update, :organization, organization: current_organization
        end

        def index
          render json: organization_blueprints
        end

        def show
          render json: organization_blueprints.find(params[:id]).to_json(except: :image)
        end

        def create
          save_settings
          parse_blueprints
          @form = form(BlueprintForms).from_params(params).with_context(current_organization:)
          SaveBlueprints.call(@form) do
            on(:ok) do
              render plain: I18n.t("navigation_maps.create.success", scope: "decidim")
            end

            on(:invalid) do
              render plain: I18n.t("navigation_maps.create.error", scope: "decidim"), status: :unprocessable_entity
            end
          end
        end

        private

        # Manually save original settings if the settings array is present
        def save_settings
          return unless params[:content_block]
          return unless params[:content_block][:settings]

          @form = form(Decidim::Admin::ContentBlockForm).from_params(params)
          Decidim::Admin::ContentBlocks::UpdateContentBlock.call(@form, content_block, content_block.scope_name&.to_sym)
        end

        def content_block
          @content_block ||= Decidim::ContentBlock.where(organization: current_organization, manifest_name: :navigation_map).find(params[:content_block_id])
        end

        # Convert blueprint data to an object
        def parse_blueprints
          return unless params[:blueprints]

          params[:blueprints].each do |_key, data|
            data[:blueprint] = JSON.parse data[:blueprint] if data[:blueprint].present?
          end
        end

        def organization_blueprints
          @organization_blueprints ||= OrganizationBlueprints.new(current_organization).query
        end
      end
    end
  end
end
