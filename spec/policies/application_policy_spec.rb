require 'rails_helper'

RSpec.describe ApplicationPolicy do

  let(:user) { FactoryBot.create(:user) }
  let(:policy_scope) { ApplicationPolicy::Scope.new(user, User.all).resolve }

  subject { described_class }

  permissions ".scope" do
    it 'returns only the user' do
      expect(policy_scope).to include user
    end
  end

  permissions :show? do
    it 'should permit for existing record' do
      expect(subject).to permit(user, user)
    end
  end

  permissions :index?, :create?, :new?, :update?, :edit?, :destroy? do
    it 'should deny' do
      expect(subject).to_not permit(nil, nil)
    end
  end
end
