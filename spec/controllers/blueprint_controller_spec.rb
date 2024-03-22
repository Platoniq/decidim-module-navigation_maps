# frozen_string_literal: true

require "spec_helper"

module Decidim::NavigationMaps::Admin
  describe BlueprintsController do
    routes { Decidim::NavigationMaps::AdminEngine.routes }

    let(:user) { create(:user, :confirmed, :admin, organization:) }
    let(:organization) { create(:organization) }
    let(:params) do
      {
        blueprints: {
          "1" => {
            blueprint: json
          }
        }
      }
    end
    let(:json) { "{\"x\":0.1,\"y\":0.2}" }

    before do
      request.env["decidim.current_organization"] = user.organization
      sign_in user, scope: :user
    end

    describe "GET #index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
        expect(response.body).to eq("[]")
      end
    end

    describe "GET #show" do
      let!(:blueprint) { create(:blueprint, organization:) }

      it "returns http success" do
        get :show, params: { id: blueprint.id }
        expect(response).to have_http_status(:success)
        expect(response.parsed_body["id"]).to eq(blueprint.id)
      end
    end

    describe "POST #create" do
      it "returns http success" do
        post :create
        expect(response).to have_http_status(:success)
        # context: when no blueprint paramater
        # context: when blueprint is not valid json
        # context: when blueprint is is valid json
      end

      context "when blueprint is present" do
        it "is parsed correctly" do
          post(:create, params:)
          expect(response).to have_http_status(:success)
          expect(controller.params[:blueprints]["1"][:blueprint]).to eq("x" => 0.1, "y" => 0.2)
        end
      end
      # context "when blueprint is incorrect" do
      #   let(:json) { "asdf" }
      #   it "returns erro" do
      #     post :create, params: params
      #     expect(response).to have_http_status(:error)
      #   end
      # end
    end
  end
end
