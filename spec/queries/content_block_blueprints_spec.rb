# frozen_string_literal: true

require "spec_helper"

module Decidim::NavigationMaps
  describe ContentBlockBlueprints do
    subject { described_class.new(content_block) }

    let(:organization) { create(:organization) }
    let!(:content_block) { create(:content_block, organization:) }
    let!(:other_content_block) { create(:content_block, organization:) }
    let!(:blueprints) do
      create_list(:blueprint, 3, organization:, content_block:)
    end
    let!(:other_content_block_blueprints) do
      create_list(:blueprint, 3, organization:, content_block: other_content_block)
    end

    describe "query" do
      it "includes the content block blueprints" do
        expect(subject).to include(*blueprints)
      end

      it "doesn't include the blueprints of other content block" do
        expect(subject).not_to include(*other_content_block_blueprints)
      end
    end
  end
end
