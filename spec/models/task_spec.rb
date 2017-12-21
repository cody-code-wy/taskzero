require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'factory' do
    it 'should have a valid factory' do
      expect(FactoryBot.build(:task)).to be_valid
    end
  end

  describe 'validations' do
    it 'should not be valid without name' do
      expect(FactoryBot.build(:task, name: nil)).to_not be_valid
    end
    it 'should not be valid without kind' do
      expect(FactoryBot.build(:task, kind: nil)).to_not be_valid
    end
    it 'should not be valid without user' do
      expect(FactoryBot.build(:task, user: nil)).to_not be_valid
    end
    it 'should be valid without project' do
      expect(FactoryBot.build(:task, project: nil)).to be_valid
    end
    it 'should be valid without context' do
      expect(FactoryBot.build(:task, context: nil)).to be_valid
    end
    it 'should be valid without complete' do
      expect(FactoryBot.build(:task, complete: nil)).to be_valid
    end
    it 'should be valid without delegate_note' do
      expect(FactoryBot.build(:task, delegate_note: nil)).to be_valid
    end
    it 'should be valid without delegate' do
      expect(FactoryBot.build(:task, delegate: nil)).to be_valid
    end
    it 'should be valid without deferred_date' do
      expect(FactoryBot.build(:task, deferred_date: nil)).to be_valid
    end
    it 'should be valid without description' do
      expect(FactoryBot.build(:task, description: nil)).to be_valid
    end
  end

  it 'kind should be in the enum kinds' do
    Task.kinds.each do |kind, num|
      expect(FactoryBot.build(:task, kind: kind)).to be_valid
    end
  end

  describe 'relations' do
    before do
      @task = FactoryBot.build(:task, :with_project, :with_context)
    end
    it 'should have a user' do
      expect(@task.user).to be_a User
    end
    it 'should have a project' do
      expect(@task.project).to be_a Project
    end
    it 'should have a context' do
      expect(@task.context).to be_a Context
    end
  end
end
