require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do

  describe 'logged_in?' do
    context 'while logged in' do
      before do
        @user = FactoryBot.create(:user)
        session[:user_id] = @user.id
      end
      it 'should be truthy' do
        expect(controller.send(:logged_in?)).to be_truthy
      end
      it 'should return the user' do
        expect(controller.send(:logged_in?)).to eq @user
      end
    end
    context 'while logged out' do
      it 'should be falsy' do
        expect(controller.send(:logged_in?)).to be_falsy
      end
      it 'should be nil' do
        expect(controller.send(:logged_in?)).to be_nil
      end
    end
  end

end
