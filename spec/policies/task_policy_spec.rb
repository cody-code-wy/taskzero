require 'rails_helper'

RSpec.describe TaskPolicy do

  let(:user) { FactoryBot.build(:user) }
  let(:policy_scope) { TaskPolicy::Scope.new(user, Task.all).resolve }

  subject { described_class }

  permissions ".scope" do
    context 'logged in' do
      it 'shown tasks owned by user' do
        task = FactoryBot.create(:task, user: user)
        expect(policy_scope).to include task
      end
      it 'hides tasks owned by other users' do
        FactoryBot.create(:task)
        expect(policy_scope).to be_empty
      end
    end
  end

  permissions :show?, :update?, :destroy? do
    context 'logged out' do
      it 'should deny access' do
        expect(subject).to_not permit(nil, FactoryBot.build(:task))
      end
    end
    context 'logged in' do
      before do
        @record = FactoryBot.build(:task, user: user)
      end
      it 'should allow access to record' do
        expect(subject).to permit(user, @record)
      end
      it 'should deny access to record owned by different user' do
        expect(subject).to_not permit(user, FactoryBot.build(:task))
      end
    end
  end

  permissions :create?, :index? do
    context 'logged out' do
      it 'should deny access' do
        expect(subject).to_not permit(nil, FactoryBot.build(:task))
      end
    end
    context 'logged in' do
      it 'should allow access' do
        expect(subject).to permit(user, Task)
      end
    end
  end
end
