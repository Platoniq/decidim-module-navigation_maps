# frozen_string_literal: true

require "spec_helper"

module Decidim::NavigationMaps
  describe SaveArea do
    subject { described_class.new(form) }

    let(:blueprint) { create :blueprint }
    let(:form) do
      double(
        AreaForm,
        area: data,
        id: id,
        title: title,
        description: title,
        link: link,
        current_blueprint: blueprint
      )
    end
    let(:data) do
      { x: 0.5, y: 0.6 }
    end
    let(:title) { Decidim::Faker::Localized.sentence(2) }
    let(:description) { Decidim::Faker::Localized.paragraph }
    let(:id) { nil }
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
      let!(:blueprint_area) { create(:blueprint_area, blueprint: blueprint) }
      let(:id) { blueprint_area.id }

      it "broadcasts ok" do
        expect { subject.call }.to broadcast(:ok)
      end

      it "creates the area" do
        expect { subject.call }.to change(BlueprintArea, :count).by(0)
      end
    end

    context "when id does not exist" do
      let(:blueprint_area) { build(:blueprint_area, id: id, blueprint: blueprint) }
      let(:id) { 11101 }

      it "broadcasts ok" do
        expect { subject.call }.to broadcast(:ok)
      end

      it "creates the area" do
        expect { subject.call }.to change(BlueprintArea, :count).by(1)
      end
    end
  end
end
