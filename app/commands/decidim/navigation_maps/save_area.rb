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

        broadcast(:ok, @area)
      end

      private

      attr_reader :form, :current_blueprint

      def initialize_area
        @area = BlueprintArea.find_or_initialize_by(area_id: form.area_id, blueprint: @form.context.current_blueprint)
      end

      def update_area
        @area.link = form.link
        @area.color = form.color if form.color
        @area.area_id = form.area_id if form.area_id
        @area.area = form.area if form.area
        @area.area_type = form.area_type if form.area_type
      end

      def save_area!
        @area.save!
      end
    end
  end
end
