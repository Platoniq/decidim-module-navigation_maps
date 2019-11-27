# frozen_string_literal: true

require "spec_helper"

module Decidim
  module NavigationMaps
    describe Blueprint do
      subject { blueprint }

      let(:organization) { create(:organization) }
      let(:blueprint) { create(:blueprint, organization: organization) }

      it { is_expected.to be_valid }

      it "is associated with organization" do
        expect(subject.organization).to eq(organization)
      end

      context "when the file is too big" do
        before do
          expect(subject.image).to receive(:size).and_return(11.megabytes)
        end

        it { is_expected.not_to be_valid }
      end

      context "when the file is a malicious image" do
        let(:image_path) { Decidim::Dev.asset("malicious.jpg") }
        let(:blueprint) do
          build(
            :blueprint,
            image: Rack::Test::UploadedFile.new(image_path, "image/jpg")
          )
        end

        it { is_expected.not_to be_valid }
      end

      context "when areas are defined" do
        let!(:blueprint) { create(:blueprint, organization: organization) }
        let!(:area1) { create(:blueprint_area, link: "#link", color: "#f00", title: title, description: description, blueprint: blueprint) }
        let!(:area2) { create(:blueprint_area, link: "#another_link", color: "#f0f", title: title, description: description, blueprint: blueprint) }
        let!(:area3) { create(:blueprint_area, area: data) }

        let(:blueprint_object) do
          {
            "101" => {
              type: "Feature",
              geometry: data,
              properties: {
                link: "#link",
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
          expect(area1.blueprint).to eq(blueprint)
          expect(area2.blueprint).to eq(blueprint)
          expect(area3.blueprint).not_to eq(blueprint)
        end

        it "blueprint contains areas" do
          expect(blueprint.areas).to include(area1)
          expect(blueprint.areas).to include(area2)
          expect(blueprint.areas).not_to include(area3)
        end

        it "compacts json areas in a single object" do
          area1.area = data
          area1.area_id = "101"
          area1.save
          area2.area = data
          area2.area_id = "102"
          area2.save
          expect(blueprint.blueprint).to eq(blueprint_object)
        end
      end
    end
  end
end
