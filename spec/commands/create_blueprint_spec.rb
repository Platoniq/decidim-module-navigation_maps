# frozen_string_literal: true

require "spec_helper"

module Decidim::NavigationMaps
  describe CreateBlueprints do
    subject { described_class.new(form) }

    let(:organization) { create :organization }
    let(:form) do
      instance_double(
        BlueprintForms,
        organization: organization
      )

      context "when everything is ok" do
        it "broadcasts ok" do
          expect { subject.call }.to broadcast(:ok)
        end
      end
    end
  end
end
