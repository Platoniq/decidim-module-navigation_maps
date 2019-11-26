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

        def new; end

        def show
          @form = AreaForm.from_model(area)
        end

        def update
          @form = form(AreaForm).from_params(params, current_blueprint: blueprint)

          SaveArea.call(@form) do
            on(:ok) do |_message|
              render json: { message: I18n.t("navigation_maps.admin.areas.update.success", scope: "decidim") }
            end

            on(:invalid) do |message|
              render json: { message: I18n.t("navigation_maps.admin.areas.update.error", scope: "decidim"), error: message }, status: :unprocessable_entity
            end
          end
        end

        private

        def blueprint
          @blueprint ||= Blueprint.find(params[:blueprint_id])
        end

        def area
          @area ||= BlueprintArea.find(params[:id])
        end
      end
    end
  end
end
