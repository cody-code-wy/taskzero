require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe 'Post #create' do
    let(:valid_session) { {} }
    context 'Good Login' do
      before do
        @password = Faker::Internet.password(8)
        @user = FactoryBot.create(:user, password: @password, password_confirmation: @password)
      end
      let(:login_params) {{email: @user.email, password: @password} }
      it 'returns http found (302)' do
        post :create, params: login_params, session: valid_session
        expect(response).to have_http_status(:found)
      end
      it 'should change session[:user_id]' do
        expect{
          post :create, params: login_params, session: valid_session
        }.to change { session[:user_id] }.to @user.id
      end
      it 'should set flash[:notice]' do
        expect {
          post :create, params: login_params, session: valid_session
        }.to change { flash[:notice] }.to "Welcome back #{@user.first_name}!"
      end
    end
    context 'Bad Login' do
      let(:login_params) {{email: Faker::Internet.email, password: Faker::Internet.password(8)}}
      it 'returns http success' do
        post :create, params: login_params, session: valid_session
        expect(response).to have_http_status(:success)
      end
      it 'should not change session[:user_id]' do
        expect{
          post :create, params: login_params, session: valid_session
        }.to_not change { session[:user_id] }
      end
      it 'should set flash[:notice]' do
        expect {
          post :create, params: login_params, session: valid_session
        }.to change { flash[:notice] }.to 'Email or Password is Invalid'
      end
    end
  end

  describe "GET #destroy" do
    it 'returns http found (302)' do
      get :destroy
      expect(response).to have_http_status(:found)
    end
    it 'should clear session[:user_id]' do
      session[:user_id] = 1
      expect { get :destroy }.to change { session[:user_id] }.to nil
    end
    it 'should set flash[:notice]' do
      expect {
        get :destroy
      }.to change { flash[:notice] }.to 'You have been signed out.'
    end
  end

end
