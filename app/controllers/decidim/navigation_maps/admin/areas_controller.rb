# frozen_string_literal: true

module Decidim
  module NavigationMaps
    module Admin
      class AreasController < ::Decidim::NavigationMaps::Admin::ApplicationController
        layout false
        helper_method :link_suggestions

        before_action do
          enforce_permission_to :update, :organization, organization: current_organization
        end

        def index
          render json: blueprint.areas
        end

        def show
          @form = form(AreaForm).from_model(area)
        end

        def new
          @form = form(AreaForm).instance(current_blueprint: blueprint)
        end

        def create
          parse_areas
          @form = form(AreaForm).from_params(params, current_blueprint: blueprint)

          SaveArea.call(@form) do
            on(:ok) do |area|
              render json: { message: I18n.t("navigation_maps.admin.areas.create.success", scope: "decidim"),
                             area_id: area.area_id,
                             blueprint_id: area.blueprint.id,
                             area: area.to_geoson }
            end

            on(:invalid) do |message|
              render json: { message: I18n.t("navigation_maps.admin.areas.create.error", scope: "decidim"), error: message }, status: :unprocessable_entity
            end
          end
        end

        def update
          parse_areas
          @form = form(AreaForm).from_params(params, current_blueprint: blueprint)

          SaveArea.call(@form) do
            on(:ok) do |area|
              render json: { message: I18n.t("navigation_maps.admin.areas.update.success", scope: "decidim"),
                             area_id: area.area_id,
                             blueprint_id: area.blueprint.id,
                             area: area.to_geoson }
            end

            on(:invalid) do |message|
              render json: { message: I18n.t("navigation_maps.admin.areas.update.error", scope: "decidim"), error: message }, status: :unprocessable_entity
            end
          end
        end

        private

        def link_suggestions
          return if blueprints_count.zero?

          maps = blueprints_count.times.collect do |n|
            "<a href=\"#map#{n}\">#map#{n}</a>"
          end
          t("link_suggestions", scope: "decidim.navigation_maps.admin.areas.show", map: maps.join(",")).html_safe
        end

        def parse_areas
          return unless params[:blueprint_area]
          return if params[:blueprint_area][:area].blank?

          feature = JSON.parse params[:blueprint_area][:area]
          params[:blueprint_area][:area] = feature["geometry"] if feature["geometry"]
          params[:blueprint_area][:area_type] = feature["type"] if feature["type"]
        end

        def blueprint
          @blueprint ||= Blueprint.find(params[:blueprint_id])
        end

        def area
          @area ||= BlueprintArea.find_by(area_id: params[:area_id], blueprint:)
        end

        def blueprints_count
          @blueprints_count ||= Blueprint.where(organization: current_organization).count
        end
      end
    end
  end
end
