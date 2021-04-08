# frozen_string_literal: true

require "spec_helper"

module Decidim::NavigationMaps
  describe SaveBlueprints do
    subject { described_class.new(forms) }

    let(:organization) { create :organization }
    let(:content_block) { create :content_block, organization: organization, manifest_name: :navigation_map, scope_name: :homepage }

    let(:forms) do
      instance_double(
        BlueprintForms,
        blueprints: blueprints,
        current_organization: organization,
        content_block_id: content_block.id
      )
    end
    let(:blueprints) { [form1, form2] }
    let(:form1) do
      double(
        BlueprintForm,
        blueprint: blueprint_object,
        id: id,
        title: title,
        height: height,
        description: title,
        remove: remove,
        image: uploaded_image
      )
    end
    let(:form2) do
      double(
        BlueprintForm,
        blueprint: blueprint_object,
        id: 2,
        title: title,
        height: height,
        description: nil,
        remove: false,
        image: nil
      )
    end
    let(:blueprint_object) do
      {
        "1" => {
          type: "Feature",
          geometry: data
        }
      }
    end
    let(:data) do
      { x: 0.5, y: 0.6 }
    end
    let(:title) { Decidim::Faker::Localized.sentence(word_count: 2) }
    let(:height) { 500 }
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

      it "creates all blueprints belonging to content block" do
        expect { subject.call }.to change(Blueprint.where(content_block: content_block), :count).by(2)
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
