# frozen_string_literal: true

require "spec_helper"

module Decidim::NavigationMaps
  describe AreaForm do
    subject { described_class.from_params(attributes).with_context(context) }

    let(:blueprint) { create(:blueprint) }
    let(:title) { Decidim::Faker::Localized.sentence(word_count: 2) }
    let(:description) { Decidim::Faker::Localized.paragraph }
    let(:area) do
      {
        "x" => "x data",
        "y" => "y data"
      }
    end
    let(:attributes) do
      {
        title:,
        description:,
        area:
      }
    end
    let(:context) do
      {
        "current_blueprint" => blueprint
      }
    end

    context "when everything is OK" do
      it { is_expected.to be_valid }
    end
  end
end
