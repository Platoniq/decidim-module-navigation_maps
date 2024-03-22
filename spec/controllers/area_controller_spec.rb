# frozen_string_literal: true

require "spec_helper"

module Decidim::NavigationMaps::Admin
  describe AreasController do
    routes { Decidim::NavigationMaps::AdminEngine.routes }

    let(:organization) { create(:organization) }
    let(:user) { create(:user, :confirmed, :admin, organization:) }
    let(:blueprint) { create(:blueprint, organization:) }

    let(:attributes) do
      {
        blueprint_id: blueprint.id,
        area_id: area.area_id,
        blueprint_area: {
          area: json,
          id:,
          title:,
          description: title,
          link:,
          color:
        }
      }
    end
    let(:json) { "{\"geometry\":\"{}\",\"type\":\"Feature\"}" }
    let(:title) { Decidim::Faker::Localized.sentence(word_count: 2) }
    let(:description) { Decidim::Faker::Localized.paragraph }
    let(:id) { nil }
    let(:link) { "#link" }
    let(:color) { "#f0f" }

    before do
      request.env["decidim.current_organization"] = user.organization
      sign_in user, scope: :user
    end

    describe "GET #index" do
      it "returns http success" do
        get :index, params: { blueprint_id: blueprint.id }
        expect(response).to have_http_status(:success)
        expect(response.body).to eq("[]")
      end
    end

    describe "GET #show" do
      context "when area exists" do
        let!(:area) { create(:blueprint_area, blueprint:) }

        it "returns http success" do
          get :show, params: attributes
          expect(response).to have_http_status(:success)
        end
      end

      context "when area does not exist" do
        it "returns http success" do
          get :show, params: { blueprint_id: blueprint.id, area_id: 1111 }
          expect(response).to have_http_status(:success)
        end
      end
    end

    describe "POST #create" do
      let!(:area) { create(:blueprint_area, blueprint:) }

      it "returns http success" do
        post :create, params: attributes
        expect(response).to have_http_status(:success)
      end
    end

    describe "POST #update" do
      let!(:area) { create(:blueprint_area, blueprint:) }

      it "returns http success" do
        post :update, params: attributes
        expect(response).to have_http_status(:success)
      end
    end
  end
end
