# frozen_string_literal: true

require "spec_helper"

module Decidim::NavigationMaps
  describe BlueprintForm do
    subject { described_class.from_params(attributes).with_context(context) }

    let(:organization) { create :organization }
    let(:title) { Decidim::Faker::Localized.sentence(2) }
    let(:attributes) do
      {
        title: title,
        blueprint: {
          "x" => "x data",
          "y" => "y data"
        }
      }
    end
    let(:context) do
      {
        "current_organization" => organization
      }
    end

    context "when everything is OK" do
      it { is_expected.to be_valid }
    end

    context "when there is no title" do
      let(:title) { nil }

      it { is_expected.not_to be_valid }
    end
  end
end
