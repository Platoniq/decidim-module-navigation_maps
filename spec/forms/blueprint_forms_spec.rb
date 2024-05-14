# frozen_string_literal: true

require "spec_helper"

module Decidim::NavigationMaps
  describe BlueprintForms do
    subject { described_class.from_params(attributes).with_context(context) }

    let(:organization) { create(:organization) }
    let(:content_block) { create(:content_block, organization:) }
    let(:attributes) do
      {
        "blueprints" => []
      }
    end
    let(:context) do
      {
        "current_organization" => organization,
        "content_block_id" => content_block.id
      }
    end

    context "when everything is OK" do
      it { is_expected.to be_valid }
    end
  end
end
