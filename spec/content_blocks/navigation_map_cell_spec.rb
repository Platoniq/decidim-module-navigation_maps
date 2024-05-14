# frozen_string_literal: true

require "spec_helper"

module Decidim::NavigationMaps::ContentBlocks
  describe NavigationMapCell, type: :cell do
    subject { cell(content_block.cell, content_block).call }

    let(:organization) { create(:organization) }
    let(:content_block) { create(:content_block, organization:, manifest_name: :navigation_map, scope_name: :homepage, settings:) }
    let(:settings) do
      {
        title: Decidim::Faker::Localized.word,
        autohide_tabs:
      }
    end
    let(:title) do
      { "en" => "I am Yertle the turtle king" }
    end
    let!(:blueprint) { create(:blueprint, organization:, content_block:, title:) }
    let(:autohide_tabs) { false }

    controller Decidim::PagesController

    context "when there are blueprints in the organization" do
      it "contains the map" do
        expect(subject.to_s).to include(blueprint.attached_uploader(:image).path)
      end

      it "contains the navigation tabs" do
        expect(subject.to_s).to include(title["en"])
      end
    end

    context "when autohide_tabs is enabled" do
      let(:autohide_tabs) { true }

      context "and there's only one blueprint" do
        it "contains the map" do
          expect(subject.to_s).to include(blueprint.attached_uploader(:image).path)
        end

        it "contains the navigation tabs" do
          expect(subject.to_s).not_to include(title["en"])
        end
      end

      context "and there's more than one blueprint" do
        let!(:blueprint2) { create(:blueprint, organization:, content_block:) }

        it "contains the map" do
          expect(subject.to_s).to include(blueprint.attached_uploader(:image).path)
        end

        it "contains the navigation tabs" do
          expect(subject.to_s).to include(title["en"])
        end
      end
    end
  end
end
