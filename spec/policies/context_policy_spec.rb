require 'rails_helper'

RSpec.describe ContextPolicy do

  let(:user) { FactoryBot.build(:user) }
  let(:policy_scope) { ContextPolicy::Scope.new(user, Context.all).resolve }

  subject { described_class }

  permissions ".scope" do
    context 'logged in' do
      it 'shows contexts owned by user' do
        context = FactoryBot.create(:context, user: user)
        expect(policy_scope).to include context
      end
      it 'hides contexts owned by other users' do
        FactoryBot.create(:context)
        expect(policy_scope).to be_empty
      end
    end
  end

  permissions :show?, :update?, :destroy? do
    context 'logged out' do
      it 'should deny access' do
        expect(subject).to_not permit(nil, FactoryBot.build(:context))
      end
    end
    context 'logged in' do
      before do
        @record = FactoryBot.build(:context, user: user)
      end
      it 'should allow access to record owned by user' do
        expect(subject).to permit(user, @record)
      end
      it 'sohuld deny access to record owned by different user' do
        expect(subject).to_not permit(user, FactoryBot.build(:context))
      end
    end

  end

  permissions :create?, :index? do
    context 'logged out' do
      it 'should deny access' do
        expect(subject).to_not permit(nil, Context)
      end
    end
    context 'logged in' do 
      it 'should allow access' do
        expect(subject).to permit(user, Context)
      end
    end
  end
end
