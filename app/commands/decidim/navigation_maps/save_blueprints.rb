# frozen_string_literal: true

module Decidim
  module NavigationMaps
    # This command creates or updates the blueprints for the organization and
    # content block.
    class SaveBlueprints < Rectify::Command
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

          initialize_blueprint(form)
          if form.remove
            destroy_blueprint!(form)
          else
            create_areas(form.blueprint) if form.blueprint
            destroy_areas_except(form.blueprint.keys) if form.blueprint
            update_blueprint!(form)
          end
        end

        broadcast(:ok)
      end

      private

      attr_reader :forms

      def initialize_blueprint(form)
        @blueprint = Blueprint.find_or_initialize_by(id: form.id) do |blueprint|
          blueprint.organization = @forms.current_organization
          blueprint.content_block = content_block
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

      def destroy_areas_except(except)
        @blueprint.areas.where.not(area_id: except).destroy_all
      end

      def content_block
        Decidim::ContentBlock.where(organization: @forms.current_organization, manifest_name: :navigation_map).find_by(id: @forms.content_block_id)
      end

      def create_areas(blueprint)
        blueprint.each do |key, area|
          a = BlueprintArea.find_or_initialize_by(area_id: key, blueprint: @blueprint)
          a.area = area[:geometry]
          a.area_type = area[:type]
        end
      end
    end
  end
end
