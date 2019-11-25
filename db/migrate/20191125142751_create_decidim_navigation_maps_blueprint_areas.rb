# frozen_string_literal: true

class CreateDecidimNavigationMapsBlueprintAreas < ActiveRecord::Migration[5.2]
  class Blueprint < ApplicationRecord
    self.table_name = "decidim_navigation_maps_blueprints"
  end

  class Area < ApplicationRecord
    self.table_name = "decidim_navigation_maps_blueprint_areas"
  end

  def change
    create_table :decidim_navigation_maps_blueprint_areas do |t|
      t.jsonb :area
      t.references :decidim_navigation_maps_blueprint, null: false, foreign_key: true, index: { name: "decidim_navigation_maps_constraint_blueprint_id" }
      t.jsonb :title, default: {}
      t.jsonb :description, default: {}
      t.string :area_type
      t.string :url

      t.timestamps
    end

    # Search areas and create distributed entries
    Blueprint.find_each do |blueprint|
      next unless blueprint.blueprint

      blueprint.blueprint.each do |_key, area|
        Area.create!(
          area: area,
          decidim_navigation_maps_blueprint_id: blueprint.id,
          area_type: "link",
          url: area["properties"]["link"]
        )
      end
    end

    remove_column :decidim_navigation_maps_blueprints, :blueprint, :jsonb
  end
end
