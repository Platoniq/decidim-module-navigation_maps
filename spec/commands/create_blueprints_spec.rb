# frozen_string_literal: true

require "spec_helper"

module Decidim::NavigationMaps
  describe CreateBlueprints do
    subject { described_class.new(forms) }

    let(:organization) { create :organization }
    let(:forms) do
      instance_double(
        BlueprintForms,
        blueprints: blueprints,
        current_organization: organization
      )
    end
    let(:blueprints) { [form1, form2] }
    let(:form1) do
      double(
        BlueprintForm,
        blueprint: data,
        id: id,
        title: title,
        description: title,
        remove: remove,
        image: uploaded_image
      )
    end
    let(:form2) do
      double(
        BlueprintForm,
        blueprint: data,
        id: 2,
        title: title,
        description: nil,
        remove: false,
        image: nil
      )
    end
    let(:data) do
      { x: 0.5, y: 0.6 }
    end
    let(:title) { Decidim::Faker::Localized.sentence(2) }
    let(:id) { 1 }
    let(:remove) { false }
    let(:uploaded_image) do
      Rack::Test::UploadedFile.new(
        Decidim::Dev.test_file("city.jpeg", "image/jpeg"),
        "image/jpeg"
      )
    end

    before do
      allow(form1).to receive(:invalid?).and_return(false)
      allow(form2).to receive(:invalid?).and_return(false)
    end

    context "when everything is ok" do
      it "broadcasts ok" do
        expect { subject.call }.to broadcast(:ok)
      end

      it "creates all the blueprints" do
        expect { subject.call }.to change(Blueprint, :count).by(2)
      end
    end

    context "when one form is invalid" do
      before do
        allow(form1).to receive(:invalid?).and_return(true)
      end

      it "still broadcasts ok" do
        expect { subject.call }.to broadcast(:ok)
      end

      it "creates one blueprint" do
        expect { subject.call }.to change(Blueprint, :count).by(1)
      end
    end

    context "when one form is removed" do
      let!(:blueprint) { create(:blueprint, organization: organization) }
      let(:remove) { true }
      let(:id) { blueprint.id }
      let(:blueprints) { [form1] }

      it "still broadcasts ok" do
        expect { subject.call }.to broadcast(:ok)
      end

      it "creates one blueprint" do
        expect { subject.call }.to change(Blueprint, :count).by(-1)
      end
    end
  end
end
