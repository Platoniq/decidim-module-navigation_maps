# frozen_string_literal: true

require "spec_helper"

module Decidim::NavigationMaps::ContentBlocks
  describe GroupsNavigationMapCell, type: :cell do
    subject { cell(group_content_block.cell, group_content_block).call }

    let(:organization) { create(:organization) }
    let(:group_content_block) do
      create(
        :content_block,
        organization:,
        manifest_name: :navigation_map,
        scope_name: :participatory_process_group_homepage
      )
    end
    let(:organization_homepage_content_block) do
      create(
        :content_block,
        organization:,
        manifest_name: :navigation_map,
        scope_name: :homepage
      )
    end
    let!(:group_blueprint) { create(:blueprint, organization:, content_block: group_content_block) }
    let!(:organization_homepage_blueprint) { create(:blueprint, organization:, content_block: organization_homepage_content_block) }

    controller Decidim::PagesController

    context "when there are blueprints in the content block" do
      it "contains the map" do
        expect(subject.to_s).to include(group_blueprint.attached_uploader(:image).path)
        expect(subject.to_s).not_to include(organization_homepage_blueprint.attached_uploader(:image).path)
      end
    end
  end
end
