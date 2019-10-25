# frozen_string_literal: true

require 'spec_helper'

module Decidim
  module NavigationMaps
    describe Blueprint do
      subject { blueprint }
      let(:organization) { create(:organization) }
      let(:data) { [x: "test"] }
      let(:blueprint) { build(:blueprint, blueprint: data, organization: organization) }


      it { is_expected.to be_valid }

      it "is associated with organization" do
        expect(subject.organization).to eq(organization)
      end
      
      context "when no data" do
        let(:data) { [] }
        it "is not valid" do
          expect(subject).not_to be_valid
        end
      end
    end
  end
end