require 'rails_helper'

RSpec.describe UserPolicy do

  let(:user) { User.new }

  subject { described_class }

  permissions :show?, :edit?, :update?, :destroy? do
    before do
      @record = FactoryBot.create(:user)
    end
    context 'logged out' do
      it 'should deny access' do
        expect(subject).to_not permit(nil, @record)
      end
    end
    context 'logged in' do
      before do
        @user = @record
      end
      it 'should allow access' do
        expect(subject).to permit(@user, @record)
      end
      context 'accessing different account' do
        before do
          @user = FactoryBot.create(:user)
        end
        it 'should deny access' do
          expect(subject).to_not permit(@user, @record)
        end
      end
    end
  end

  permissions :new?, :create? do
    context 'logged out' do
      it 'should allow access' do
        expect(subject).to permit(nil, User)
      end
    end
    context 'logged in' do
      it 'should deny access' do
        expect(subject).to_not permit(FactoryBot.create(:user), User)
      end
    end
  end

end
