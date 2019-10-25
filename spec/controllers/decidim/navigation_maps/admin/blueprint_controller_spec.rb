# frozen_string_literal: true

require "spec_helper"

module Decidim::NavigationMaps::Admin
  describe BlueprintsController, type: :controller do
    routes { Decidim::NavigationMaps::AdminEngine.routes }

    let(:user) { create(:user, :confirmed, :admin, organization: organization) }
    let(:organization) do
      create(:organization)
    end

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

    describe "GET #new" do
      it "returns http success" do
        get :new
        expect(response).to have_http_status(:success)
      end
    end

    describe "GET #create" do
      it "returns http success" do
        get :create
        expect(response).to have_http_status(:success)
        # context: when no blueprint paramater
        # context: when blueprint is not valid json
        # context: when blueprint is is valid json
      end
    end
  end
end
