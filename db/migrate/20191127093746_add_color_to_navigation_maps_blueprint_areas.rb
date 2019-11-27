# frozen_string_literal: true

class AddColorToNavigationMapsBlueprintAreas < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_navigation_maps_blueprint_areas, :color, :string
  end
end
