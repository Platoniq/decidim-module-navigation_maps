# frozen_string_literal: true

require "spec_helper"

module Decidim
  module NavigationMaps
    describe Blueprint do
      subject { blueprint }

      let(:organization) { create(:organization) }
      let(:content_block) { create(:content_block, organization:) }
      let(:blueprint) { create(:blueprint, organization:, content_block:) }

      it { is_expected.to be_valid }

      it "is associated with content_block" do
        expect(subject.content_block).to eq(content_block)
      end

      it "is associated with organization" do
        expect(subject.organization).to eq(organization)
      end

      it "has a default height" do
        expect(subject.height).to eq(475)
      end

      context "when the file is a malicious image" do
        let(:image_path) { Decidim::Dev.asset("malicious.jpg") }
        let(:blueprint) do
          build(
            :blueprint,
            image: ActiveStorage::Blob.create_and_upload!(
              io: File.open(image_path),
              filename: "image.jpeg",
              content_type: "image/jpeg"
            )
          )
        end

        it { is_expected.not_to be_valid }
      end

      context "when areas are defined" do
        let!(:blueprint) { create(:blueprint, organization:) }
        let!(:area) { create(:blueprint_area, link: "#link", color: "#f00", title:, description:, blueprint:) }
        let!(:other_area) { create(:blueprint_area, link: "#another_link", color: "#f0f", title:, description:, blueprint:) }
        let!(:another_area) { create(:blueprint_area, area: data) }

        let(:blueprint_object) do
          {
            "101" => {
              type: "Feature",
              geometry: data,
              properties: {
                link: "#link",
                popup: false,
                color: "#f00",
                title: title[:en],
                description: description[:en]
              }
            },
            "102" => {
              type: "Feature",
              geometry: data,
              properties: {
                link: "#another_link",
                popup: false,
                color: "#f0f",
                title: title[:en],
                description: description[:en]
              }
            }
          }
        end
        let(:title) do
          { en: "Eng title" }
        end
        let(:description) do
          { en: "Eng description" }
        end
        let(:data) do
          {
            "x" => "coord x",
            "y" => "coord y"
          }
        end

        it { is_expected.to be_valid }

        it "areas belong to blueprint" do
          expect(area.blueprint).to eq(blueprint)
          expect(other_area.blueprint).to eq(blueprint)
          expect(another_area.blueprint).not_to eq(blueprint)
        end

        it "blueprint contains areas" do
          expect(subject.areas).to include(area)
          expect(subject.areas).to include(other_area)
          expect(subject.areas).not_to include(another_area)
        end

        it "compacts json areas in a single object" do
          area.area = data
          area.area_id = "101"
          area.save
          other_area.area = data
          other_area.area_id = "102"
          other_area.save
          expect(subject.blueprint).to eq(blueprint_object)
        end
      end
    end
  end
end
