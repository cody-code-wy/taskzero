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
    context 'While Logged in as invalid user' do
      before do
        @user = FactoryBot.create(:user)
        session[:user_id] = @user.id+1
      end
      it 'should be falsy' do
        expect(controller.send(:logged_in?)).to be_falsy
      end
      it 'should be nil' do
        expect(controller.send(:logged_in?)).to be_nil
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

  describe 'current_user' do
    it 'should call logged_in?' do
      expect(controller).to receive(:logged_in?).once
      controller.send(:current_user)
    end
    it 'should return same as logged_in?' do
      @user = FactoryBot.build(:user)
      expect(controller).to receive(:logged_in?).once { @user }
      expect(controller.send(:current_user)).to be @user
    end
  end

end
