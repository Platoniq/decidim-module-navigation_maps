# frozen_string_literal: true

require "spec_helper"

module Decidim::NavigationMaps
  describe BlueprintForm do
    subject { described_class.from_params(attributes).with_context(context) }

    let(:organization) { create :organization }
    let(:attributes) do
      {
        title: title,
        id: id,
        image: image,
        blueprint: {
          "x" => "x data",
          "y" => "y data"
        }
      }
    end
    let(:title) { Decidim::Faker::Localized.sentence(2) }
    let(:id) { 101 }
    let(:image) { {} }
    let(:context) do
      {
        "current_organization" => organization
      }
    end

    before do
      allow(subject.image).to receive(:url).and_return(true)
      allow(subject.image).to receive(:content_type).and_return("image/jpeg")
    end

    context "when everything is OK" do
      it { is_expected.to be_valid }

      it "ident matches id" do
        expect(subject.ident).to eq(id)
      end

      it "image? responds true" do
        expect(subject.image?).to eq(true)
      end
    end

    context "when there is no title" do
      let(:title) { nil }

      it { is_expected.not_to be_valid }
    end

    context "when there is no id" do
      let(:id) { nil }

      it "ident is an underscore" do
        expect(subject.ident).to eq("_")
      end
    end

    context "when there is no image" do
      let(:image) { nil }

      it "image? responds false" do
        expect(subject.image?).not_to eq(true)
      end
    end
  end
end
