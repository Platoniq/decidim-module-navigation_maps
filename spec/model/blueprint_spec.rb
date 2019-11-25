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
        let(:blueprint) { build(:blueprint, organization: organization) }

        let(:areas) { [area1, area2] }
        let(:area1) { create(:blueprint_area, area: data1, blueprint: blueprint) }
        let(:area2) { create(:blueprint_area, area: data2, blueprint: blueprint) }
        let(:data1) { { x: "coord x", y: "coord y" } }
        let(:data2) { { x: "coord x", y: "coord y" } }

        it { is_expected.to be_valid }

        it "areas belong to blueprint" do
          expect(area1.blueprint).to eq(blueprint)
          expect(area2.blueprint).to eq(blueprint)
        end

        it "blueprint contains areas" do
          expect(blueprint.areas).to include(area1)
          expect(blueprint.areas).to include(area2)
        end
      end
    end
  end
end
