# frozen_string_literal: true

module Decidim
  module NavigationMaps
    module Admin
      class BlueprintsController < ApplicationController
        def index
          render json: []
        end

        def new
        end

        def create
          blueprint = Blueprint.first || Blueprint.new(organization: current_organization)
          blueprint.blueprint = params[:blueprint]
          blueprint.save!
          render json: {"blueprint": blueprint.blueprint}
        end

        def update
        end

        def destroy
        end
      end
    end
  end
end