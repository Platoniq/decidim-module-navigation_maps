# frozen_string_literal: true

class AddHeightToNavigationMapsBlueprints < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_navigation_maps_blueprints, :height, :integer, null: false, default: 475
  end
end
