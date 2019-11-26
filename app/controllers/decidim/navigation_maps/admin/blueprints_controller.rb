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
          render json: organization_blueprints.find(params[:id])
        end

        def create
          parse_blueprints
          @form = form(BlueprintForms).from_params(params).with_context(current_organization: current_organization)
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

        def parse_blueprints
          # return if params[:image]
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
