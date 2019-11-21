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
          parse_blueprints
          @form = form(BlueprintForms).from_params(params).with_context(current_organization: current_organization)
          CreateBlueprints.call(@form) do
            on(:ok) do
              render json: { success: I18n.t("navigation_maps.create.success", scope: "decidim") }
            end

            on(:invalid) do
              render json: { error: I18n.t("navigation_maps.create.error", scope: "decidim") }, status: :unprocessable_entity
            end
          end
        end

        private

        def parse_blueprints
          # return if params[:image]
          return unless params[:blueprints]
          params[:blueprints].each do |key, data|
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
