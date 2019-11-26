# frozen_string_literal: true

module Decidim
  module NavigationMaps
    module Admin
      class AreasController < ::Decidim::NavigationMaps::Admin::ApplicationController
        layout false

        before_action do
          enforce_permission_to :update, :organization, organization: current_organization
        end

        def index
          render json: blueprint.areas
        end

        def new
          @form = form(AreaForm).instance(current_blueprint: blueprint)
        end

        def create
          parse_areas
          @form = form(AreaForm).from_params(params, current_blueprint: blueprint)

          SaveArea.call(@form) do
            on(:ok) do |area|
              render json: { message: I18n.t("navigation_maps.admin.areas.create.success", scope: "decidim"), area: area.area_id, blueprint: area.blueprint.id }
            end

            on(:invalid) do |message|
              render json: { message: I18n.t("navigation_maps.admin.areas.create.error", scope: "decidim"), error: message }, status: :unprocessable_entity
            end
          end
        end

        def show
          @form = form(AreaForm).from_model(area)
        end

        def update
          @form = form(AreaForm).from_params(params, current_blueprint: blueprint)

          SaveArea.call(@form) do
            on(:ok) do |area|
              render json: { message: I18n.t("navigation_maps.admin.areas.update.success", scope: "decidim"), area: area.area_id, blueprint: area.blueprint.id }
            end

            on(:invalid) do |message|
              render json: { message: I18n.t("navigation_maps.admin.areas.update.error", scope: "decidim"), error: message }, status: :unprocessable_entity
            end
          end
        end

        private

        def parse_areas
          return unless params[:blueprint_area]
          return unless params[:blueprint_area][:area].present?

          feature = JSON.parse params[:blueprint_area][:area]
          params[:blueprint_area][:area] = feature["geometry"] if feature["geometry"]
          params[:blueprint_area][:area_type] = feature["type"] if feature["type"]
        end

        def blueprint
          @blueprint ||= Blueprint.find(params[:blueprint_id])
        end

        def area
          @area ||= BlueprintArea.find_by(area_id: params[:area_id], blueprint: blueprint)
        end
      end
    end
  end
end
