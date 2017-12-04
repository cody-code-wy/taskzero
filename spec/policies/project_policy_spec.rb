require 'rails_helper'

RSpec.describe ProjectPolicy do

  let(:user) { FactoryBot.build(:user) }
  let(:policy_scope) { ProjectPolicy::Scope.new(user, Project.all).resolve }

  subject { described_class }

  permissions ".scope" do
    context 'logged in' do
      it 'shows projects owned by user' do
        project = FactoryBot.create(:project, user: user)
        expect(policy_scope).to include project
      end
      it 'hides projects not owned by user' do
        FactoryBot.create(:project)
        expect(policy_scope).to be_empty
      end
    end
  end

  permissions :show?, :update?, :destroy? do
    context 'logged out' do
      it 'should deny access' do
        expect(subject).to_not permit(nil, FactoryBot.build(:project))
      end
    end
    context 'logged in' do
      before do
        @record = FactoryBot.build(:project, user: user)
      end
      it 'should allow access to record owned by user' do
        expect(subject).to permit(user, @record)
      end
      it 'should deny access to record owned by different user' do
        expect(subject).to_not permit(user, FactoryBot.build(:project))
      end
    end
  end

  permissions :create?, :index? do
    context 'logged out' do
      it 'should deny access' do
        expect(subject).to_not permit(nil, Project)
      end
    end
    context 'logged in' do
      it 'should allow access' do
        expect(subject).to permit(user, Project)
      end
    end
  end

end
