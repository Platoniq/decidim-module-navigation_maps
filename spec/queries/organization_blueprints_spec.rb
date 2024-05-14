# frozen_string_literal: true

require "spec_helper"

module Decidim::NavigationMaps
  describe OrganizationBlueprints do
    subject { described_class.new(organization) }

    let!(:organization) { create(:organization) }
    let!(:blueprints) do
      create_list(:blueprint, 3, organization:)
    end

    describe "query" do
      it "includes the organization's blueprints" do
        expect(subject).to include(*blueprints)
      end
    end
  end
end
