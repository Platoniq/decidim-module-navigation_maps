# frozen_string_literal: true

require "spec_helper"

module Decidim
  module NavigationMaps
    describe BlueprintArea do
      subject { blueprint_area }

      let(:organization) { create(:organization) }
      let(:blueprint) { create(:blueprint, organization: organization) }
      let(:blueprint_area) { build(:blueprint_area, blueprint: blueprint) }
      let(:data) { { x: "coord x", y: "coord y" } }

      it { is_expected.to be_valid }

      it "blueprint is associated with organization" do
        expect(subject.blueprint).to eq(blueprint)
        expect(subject.blueprint.organization).to eq(organization)
      end

      # TODO: validate json area

      # context "when no data" do
      #   let(:data) { [] }
      #   it "is not valid" do
      #     expect(subject).not_to be_valid
      #   end
      # end
    end
  end
end
