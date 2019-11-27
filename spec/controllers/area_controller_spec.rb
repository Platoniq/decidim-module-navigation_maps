# frozen_string_literal: true

require "spec_helper"

module Decidim::NavigationMaps::Admin
  describe AreasController, type: :controller do
    routes { Decidim::NavigationMaps::AdminEngine.routes }

    let(:organization) { create(:organization) }
    let(:user) { create(:user, :confirmed, :admin, organization: organization) }
    let(:blueprint) { create(:blueprint, organization: organization) }

    let(:attributes) do
      {
        blueprint_area: {
          area: data,
          id: id,
          title: title,
          description: title,
          link: link,
          current_blueprint: blueprint
        }
      }
    end
    let(:data) do
      { x: 0.5, y: 0.6 }
    end
    let(:title) { Decidim::Faker::Localized.sentence(2) }
    let(:description) { Decidim::Faker::Localized.paragraph }
    let(:id) { nil }
    let(:link) { "#link" }

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
        let!(:area) { create(:blueprint_area, blueprint: blueprint) }

        it "returns http success" do
          get :show, params: { blueprint_id: blueprint.id, area_id: area.area_id }
          expect(response).to have_http_status(:success)
        end
      end

      context "when area does not exist" do
        it "redirects to new" do
          get :show, params: { blueprint_id: blueprint.id, area_id: 1111 }
          expect(response).to have_http_status(:success)
        end
      end
    end

    describe "POST #update" do
      let!(:area) { create(:blueprint_area, blueprint: blueprint) }

      it "returns http success" do
        post :update, params: { blueprint_id: blueprint.id, area_id: area.area_id }
        expect(response).to have_http_status(:success)
      end
    end
  end
end
