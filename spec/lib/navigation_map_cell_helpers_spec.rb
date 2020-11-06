# frozen_string_literal: true

require "spec_helper"

module Decidim::NavigationMaps
  describe NavigationMapCellHelpers do
    let(:klass) do
      Class.new do
        include NavigationMapCellHelpers

        def initialize(organization, content_block)
          @current_organization = organization
          @content_block = content_block
        end

        attr_accessor :current_organization, :content_block
      end
    end

    let(:instance) { klass.new(organization, content_block) }
    let(:organization) { create :organization }
    let(:content_block) { create :content_block, organization: organization, manifest_name: :navigation_map, scope_name: :homepage }
    let(:other_content_block) { create :content_block, organization: organization, manifest_name: :navigation_map }
    let!(:blueprint1) { create(:blueprint, organization: organization, created_at: Time.current.beginning_of_day + 1.minute, content_block: content_block) }
    let!(:blueprint2) { create(:blueprint, image: nil, organization: organization, created_at: Time.current.beginning_of_day, content_block: content_block) }
    let!(:blueprint_on_other_block) { create(:blueprint, organization: organization, content_block: other_content_block) }

    describe "#valid_blueprints" do
      it "returns one blueprint" do
        expect(instance.valid_blueprints).to eq([blueprint1])
      end
    end

    describe "#valid_blueprints?" do
      it "returns true" do
        expect(instance.valid_blueprints?).to eq(true)
      end
    end

    describe "#blueprints" do
      it "returns two blueprints belonging to content_block" do
        expect(instance.blueprints).to eq([blueprint2, blueprint1])
        expect(instance.blueprints).not_to include(blueprint_on_other_block)
      end
    end
  end
end
