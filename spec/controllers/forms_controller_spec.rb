require "rails_helper"

RSpec.describe FormsController do
  describe "#index" do
    context "when an application has been started" do
      it "renders the index page" do
        current_app = create(:common_application)
        session[:current_application_id] = current_app.id

        get :index

        expect(response).to render_template(:index)
      end
    end
  end

  describe ".skip?" do
    it "defaults to false" do
      expect(FormsController.skip?(double("foo"))).to eq(false)
    end
  end
end
