# frozen_string_literal: true

require "spec_helper"

module Decidim::NavigationMaps::ContentBlocks
  describe NavigationMapSettingsFormCell, type: :cell do
    subject { cell(content_block.cell, content_block).call }

    let(:organization) { create(:organization) }
    let(:content_block) { create(:content_block, organization:, manifest_name: :navigation_map, scope_name: :homepage) }
    let!(:blueprint) { create(:blueprint, organization:, content_block:) }
    let(:settings) { NavigationMapSettingsFormCell.new }

    controller Decidim::Admin::ApplicationController

    before do
      allow(settings).to receive(:current_organization).and_return(organization)
    end

    context "when there are blueprints in the organization" do
      it "contains the map" do
        expect(subject.to_s).to include(blueprint.attached_uploader(:image).path)
      end

      it "Cell returns a form" do
        expect(settings.blueprint_form(blueprint).ident).to eq(blueprint.id)
      end
    end
  end
end
