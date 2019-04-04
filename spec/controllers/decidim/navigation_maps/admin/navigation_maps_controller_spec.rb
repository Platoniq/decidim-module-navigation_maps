# frozen_string_literal: true

require "spec_helper"

module Decidim::NavigationMaps::Admin
  describe NavigationMapsController, type: :controller do
    routes { Decidim::NavigationMaps::AdminEngine.routes }

    describe "GET #index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
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
      end
    end

  end
end
