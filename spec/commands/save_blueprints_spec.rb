# frozen_string_literal: true

require "spec_helper"

module Decidim::NavigationMaps
  describe SaveBlueprints do
    subject { described_class.new(forms) }

    let(:organization) { create(:organization) }
    let(:content_block) { create(:content_block, organization:, manifest_name: :navigation_map, scope_name: :homepage) }

    let(:forms) do
      instance_double(
        BlueprintForms,
        blueprints:,
        current_organization: organization,
        content_block_id: content_block.id
      )
    end
    let(:blueprints) { [form, other_form] }
    let(:form) do
      double(
        BlueprintForm,
        blueprint: blueprint_object,
        id:,
        title:,
        height:,
        description: title,
        remove:,
        image: uploaded_image
      )
    end
    let(:other_form) do
      double(
        BlueprintForm,
        blueprint: blueprint_object,
        id: 2,
        title:,
        height:,
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
      allow(form).to receive(:invalid?).and_return(false)
      allow(other_form).to receive(:invalid?).and_return(false)
    end

    context "when everything is ok" do
      it "broadcasts ok" do
        expect { subject.call }.to broadcast(:ok)
      end

      it "creates all the blueprints" do
        expect { subject.call }.to change(Blueprint, :count).by(2)
      end

      it "creates all blueprints belonging to content block" do
        expect { subject.call }.to change(Blueprint.where(content_block:), :count).by(2)
      end
    end

    context "when one form is invalid" do
      before do
        allow(form).to receive(:invalid?).and_return(true)
      end

      it "still broadcasts ok" do
        expect { subject.call }.to broadcast(:ok)
      end

      it "creates one blueprint" do
        expect { subject.call }.to change(Blueprint, :count).by(1)
      end
    end

    context "when one form is removed" do
      let!(:blueprint) { create(:blueprint, organization:) }
      let(:remove) { true }
      let(:id) { blueprint.id }
      let(:blueprints) { [form] }

      it "still broadcasts ok" do
        expect { subject.call }.to broadcast(:ok)
      end

      it "creates one blueprint" do
        expect { subject.call }.to change(Blueprint, :count).by(-1)
      end
    end
  end
end
