require 'rails_helper'

RSpec.describe "Contexts", type: :request do
  describe "GET /contexts" do
    it "works! (now write some real specs)" do
      get contexts_path
      expect(response).to have_http_status(200)
    end
  end
end
