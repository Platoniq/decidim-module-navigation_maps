# frozen_string_literal: true

require "spec_helper"

module Decidim::NavigationMaps
  describe SaveArea do
    subject { described_class.new(form) }

    let(:blueprint) { create(:blueprint) }
    let(:form) do
      AreaForm
        .from_params(attributes)
        .with_context(current_blueprint: blueprint)
    end
    let(:attributes) do
      {
        area: data,
        area_id:,
        no_popup:,
        title:,
        description: title,
        link:,
        current_blueprint: blueprint
      }
    end
    let(:data) do
      { x: 0.5, y: 0.6 }
    end
    let(:title) { Decidim::Faker::Localized.sentence(word_count: 2) }
    let(:description) { Decidim::Faker::Localized.paragraph }
    let(:area_id) { nil }
    let(:no_popup) { "0" }
    let(:link) { "#link" }

    before do
      allow(form).to receive(:invalid?).and_return(false)
    end

    context "when everything is ok" do
      it "broadcasts ok" do
        expect { subject.call }.to broadcast(:ok)
      end

      it "creates the area" do
        expect { subject.call }.to change(BlueprintArea, :count).by(1)
      end
    end

    context "when id exists" do
      let!(:blueprint_area) { create(:blueprint_area, blueprint:) }
      let(:area_id) { blueprint_area.area_id }

      it "broadcasts ok" do
        expect { subject.call }.to broadcast(:ok)
      end

      it "updates the area" do
        expect { subject.call }.not_to change(BlueprintArea, :count)
      end
    end

    context "when id does not exist" do
      let(:blueprint_area) { build(:blueprint_area, id:, blueprint:) }
      let(:id) { 11_101 }

      it "broadcasts ok" do
        expect { subject.call }.to broadcast(:ok)
      end

      it "creates the area" do
        expect { subject.call }.to change(BlueprintArea, :count).by(1)
      end
    end

    context "when no popup wanted" do
      let(:no_popup) { "1" }

      it "broadcasts ok" do
        expect { subject.call }.to broadcast(:ok)
      end

      it "creates the area" do
        expect { subject.call }.to change(BlueprintArea, :count).by(1)
      end
    end
  end
end
