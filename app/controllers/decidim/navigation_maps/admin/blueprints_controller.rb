# frozen_string_literal: true

module Decidim
  module NavigationMaps
    module Admin
      class BlueprintsController < ::Decidim::NavigationMaps::Admin::ApplicationController
        def index
          render json: organization_blueprints
        end

        def create
          enforce_permission_to :update, :organization, organization: current_organization
          parse_blueprint
          @form = form(BlueprintForm).from_params(params).with_context(current_organization: current_organization)
          CreateBlueprint.call(@form) do
            on(:ok) do
              render json: { success: I18n.t("navigation_maps.create.success", scope: "decidim") }
            end

            on(:invalid) do
              render json: { error: I18n.t("navigation_maps.create.error", scope: "decidim") }, status: :unprocessable_entity
            end
          end
        end

        private

        def parse_blueprint
          params[:blueprint] = JSON.parse params[:blueprint] if params[:blueprint].present?
        end

        def organization_blueprints
          @organization_blueprints ||= OrganizationBlueprints.new(current_organization).query
        end
      end
    end
  end
end
