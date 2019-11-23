# frozen_string_literal: true

require "spec_helper"

module Decidim::NavigationMaps
  describe NavigationMapCellHelpers do
    let(:klass) do
      Class.new do
        include NavigationMapCellHelpers

        def initialize(organization)
          @current_organization = organization
        end

        attr_accessor :current_organization
      end
    end

    let(:instance) { klass.new(organization) }
    let(:organization) { create :organization }
    let!(:blueprint1) { create(:blueprint, organization: organization, created_at: Time.current.beginning_of_day + 1.minute) }
    let!(:blueprint2) { create(:blueprint, image: nil, organization: organization, created_at: Time.current.beginning_of_day) }

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
      it "returns two blueprint" do
        expect(instance.blueprints).to eq([blueprint2, blueprint1])
      end
    end
  end
end
