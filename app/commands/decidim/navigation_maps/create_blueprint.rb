# frozen_string_literal: true

module Decidim
  module NavigationMaps
    # This command creates or updates a new blueprint.
    class CreateBlueprint < Rectify::Command
      # Creates a blueprint.
      #
      # form - The form with the data.
      def initialize(form)
        @form = form
      end

      # Executes the command. Broadcasts these events:
      #
      # - :ok when everything is valid
      # - :invalid if the form wasn't valid and we couldn't proceed.
      #
      # Returns nothing.
      def call
        return broadcast(:invalid) if form.invalid?

        create_blueprint
        update_blueprint!

        broadcast(:ok)
      end

      private

      attr_reader :form, :blueprint

      def create_blueprint
        @blueprint = Blueprint.find_or_initialize_by(id: form.id) do |blueprint|
          blueprint.organization = form.current_organization
        end
      end

      def update_blueprint!
        @blueprint.image = form.image if form.image.present?
        @blueprint.blueprint = form.blueprint
        @blueprint.save!
      end
    end
  end
end
