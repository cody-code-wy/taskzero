require 'rails_helper'

RSpec.describe UserPolicy do

  let(:user) { FactoryBot.create(:user) }
  let(:policy_scope) { UserPolicy::Scope.new(user, User.all).resolve }

  subject { described_class }

  permissions ".scope" do
    it 'should have the suer' do
      expect(policy_scope).to include user
    end
    it 'should have only the user' do
      expect(policy_scope).to include user
      expect(policy_scope.count).to eq 1
    end
  end

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
