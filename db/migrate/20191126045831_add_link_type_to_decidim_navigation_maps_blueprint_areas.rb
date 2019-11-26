# frozen_string_literal: true

class AddLinkTypeToDecidimNavigationMapsBlueprintAreas < ActiveRecord::Migration[5.2]
  def change
    rename_column :decidim_navigation_maps_blueprint_areas, :url, :link
    add_column :decidim_navigation_maps_blueprint_areas, :link_type, :string
  end
end
