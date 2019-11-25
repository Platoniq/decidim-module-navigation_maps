# frozen_string_literal: true

module Decidim
  module NavigationMaps
    # This command creates or updates the blueprints for the organization.
    class CreateBlueprints < Rectify::Command
      # Creates a blueprint.
      #
      # forms - The form with the data.
      def initialize(forms)
        @forms = forms
        @blueprints = forms.blueprints || {}
      end

      # Executes the command. Broadcasts these events:
      #
      # - :ok when everything is valid
      # - :invalid if the form wasn't valid and we couldn't proceed.
      #
      # Returns nothing.
      def call
        @blueprints.each do |form|
          next if form.invalid?

          create_blueprint(form)
          if form.remove
            destroy_blueprint!(form)
          else
            delete_areas
            create_areas(form.blueprint) if form.blueprint
            update_blueprint!(form)
          end
        end

        broadcast(:ok)
      end

      private

      attr_reader :forms

      def create_blueprint(form)
        @blueprint = Blueprint.find_or_initialize_by(id: form.id) do |blueprint|
          blueprint.organization = @forms.current_organization
        end
      end

      def update_blueprint!(form)
        @blueprint.image = form.image if form.image.present?
        @blueprint.title = form.title
        @blueprint.description = form.description
        @blueprint.save!
      end

      def destroy_blueprint!(form)
        @blueprint.destroy! if form.id
      end

      def delete_areas
        @blueprint.areas.destroy_all
      end

      def create_areas(blueprint)
        blueprint.each do |_key, area|
          BlueprintArea.create!(
            blueprint: @blueprint,
            area: area[:geometry],
            area_type: area[:type],
            url: area[:properties][:link]
          )
        end
      end
    end
  end
end
