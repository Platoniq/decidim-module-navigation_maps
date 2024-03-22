# frozen_string_literal: true

require "spec_helper"

module Decidim::NavigationMaps
  describe BlueprintForm do
    subject { described_class.from_params(attributes).with_context(context) }

    let(:organization) { create(:organization) }
    let(:attributes) do
      {
        title:,
        height:,
        id:,
        image:,
        blueprint: {
          "x" => "x data",
          "y" => "y data"
        }
      }
    end
    let(:title) { Decidim::Faker::Localized.sentence(word_count: 2) }
    let(:height) { 500 }
    let(:id) { 101 }
    let(:image) { {} }
    let(:context) do
      {
        "current_organization" => organization
      }
    end

    context "when there is image" do
      before do
        allow(subject.image).to receive_messages(url: true, content_type: "image/jpeg")
      end

      context "when everything is OK" do
        it { is_expected.to be_valid }

        it "ident matches id" do
          expect(subject.ident).to eq(id)
        end

        it "image? responds true" do
          expect(subject.image?).to be(true)
        end
      end

      context "when there is no title" do
        let(:title) { nil }

        it { is_expected.not_to be_valid }
      end

      context "when there is no height" do
        let(:height) { nil }

        it { is_expected.not_to be_valid }
      end

      context "when height is not a number" do
        let(:height) { "abracadabra" }

        it { is_expected.not_to be_valid }
      end

      context "when height is not positive" do
        let(:height) { -100 }

        it { is_expected.not_to be_valid }
      end

      context "when there is no id" do
        let(:id) { nil }

        it "ident is an underscore" do
          expect(subject.ident).to eq("_")
        end
      end
    end

    context "when there is no image" do
      let(:image) { nil }

      it "image? responds false" do
        expect(subject.image?).not_to be(true)
      end
    end
  end
end
