# frozen_string_literal: true

require "spec_helper"

module Decidim
  module NavigationMaps
    describe BlueprintArea do
      subject { blueprint_area }

      let(:organization) { create(:organization) }
      let(:blueprint) { create(:blueprint, organization: organization) }
      let(:blueprint_area) { build(:blueprint_area, blueprint: blueprint) }
      let(:area) do
        {
          "x" => "coord x",
          "y" => "coord y"
        }
      end
      let(:area_id) { "101" }
      let(:title) { Decidim::Faker::Localized.sentence(2) }
      let(:description) { Decidim::Faker::Localized.paragraph }
      let(:link) { "#link" }

      it { is_expected.to be_valid }

      it "blueprint is associated with organization" do
        expect(subject.blueprint).to eq(blueprint)
        expect(subject.blueprint.organization).to eq(organization)
      end

      # TODO: validate json area
      context "when all fields are specified" do
        let!(:blueprint_area) { create(:blueprint_area, title: title, description: description, link: link, area: area, area_id: area_id, blueprint: blueprint) }

        it "saves data correctly" do
          subject.save
          subject.reload
          expect(subject.title).to eq(title)
          expect(subject.description).to eq(description)
          expect(subject.link).to eq(link)
          expect(subject.area_id).to eq(area_id)
          expect(subject.area).to eq(area)
        end
      end

      context "when no area" do
        let!(:blueprint_area) { create(:blueprint_area, area: area, area_id: area_id, blueprint: blueprint) }

        it "save data without area" do
          a = BlueprintArea.find(blueprint_area.id)
          a.title = title
          a.description = description
          a.link = link
          a.save
          # a.reload
          expect(a.title).to eq(title)
          expect(a.description).to eq(description)
          expect(a.link).to eq(link)
          expect(a.area_id).to eq(area_id)
          expect(a.area).to eq(area)
        end
      end
    end
  end
end
