# frozen_string_literal: true

module Decidim
  module NavigationMaps
    # This command creates or updates areas for a blueprints
    class SaveArea < Rectify::Command
      # Creates or updates an area for a blueprint.
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
        return broadcast(:invalid, form.errors.full_messages.join(", ")) if form.invalid?

        initialize_area
        update_area
        save_area!

        broadcast(:ok)
      end

      private

      attr_reader :form

      def initialize_area
        @area = BlueprintArea.find_or_initialize_by(id: form.id) do |area|
          area.blueprint = form.current_blueprint
        end
      end

      def update_area
        @area.link = form.link
      end

      def save_area!
        @area.save!
      end
    end
  end
end
