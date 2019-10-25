# frozen_string_literal: true

require "spec_helper"

module Decidim
  module NavigationMaps
    describe Blueprint do
      subject { blueprint }

      let(:organization) { create(:organization) }
      let(:data) { [x: "coord x", y: "coord y"] }
      let(:blueprint) { build(:blueprint, blueprint: data, organization: organization) }

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

      # TODO: validate json blueprint

      # context "when no data" do
      #   let(:data) { [] }
      #   it "is not valid" do
      #     expect(subject).not_to be_valid
      #   end
      # end
    end
  end
end
