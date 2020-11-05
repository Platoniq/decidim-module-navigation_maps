# frozen_string_literal: true

class AddReferenceToContentBlockToBlueprintsTable < ActiveRecord::Migration[5.2]
  def change
    add_reference(
      :decidim_navigation_maps_blueprints,
      :decidim_content_block,
      foreign_key: true,
      index: { name: "decidim_navigation_maps_constraint_content_block" }
    )
  end
end
