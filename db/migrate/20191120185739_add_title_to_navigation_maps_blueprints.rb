# frozen_string_literal: true

class AddTitleToNavigationMapsBlueprints < ActiveRecord::Migration[5.2]
  def change
    change_table :decidim_navigation_maps_blueprints do |t|
      t.jsonb :title, default: {}
      t.jsonb :description, default: {}
    end
  end
end
