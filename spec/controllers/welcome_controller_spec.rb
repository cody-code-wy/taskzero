require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do

  describe 'Get#index' do
    it 'return http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

end
