require 'rails_helper'

RSpec.describe Project, type: :model do
  it 'should have a valid factory' do
    expect(FactoryBot.build(:project)).to be_valid
  end

  describe 'validations' do
    it 'should be invalid without name' do
      expect(FactoryBot.build(:project, name: nil)).to_not be_valid
    end
    it 'should be invalid without kind' do
      expect(FactoryBot.build(:project, kind: nil)).to_not be_valid
    end
    it 'should be invalid without user' do
      expect(FactoryBot.build(:project, user: nil)).to_not be_valid
    end
    it 'should be invalid without project' do
      expect(FactoryBot.build(:project, project: nil)).to be_valid
    end
    it 'should be valid without on_hold' do
      expect(FactoryBot.build(:project, on_hold: nil)).to be_valid
    end
  end

  it 'on_hold should be falsy when saved with nil' do
    FactoryBot.create(:project, on_hold: nil)
    expect(Project.last.on_hold).to be_falsy
  end

  describe 'Relations' do
    before do
      @project = FactoryBot.build(:project, :with_project, :with_projects)
    end
    it 'should have a User' do
      expect(@project.user).to be_a User
    end
    it 'should have a Project' do
      expect(@project.project).to be_a Project
    end
    it 'should have Projects' do
      expect(@project.projects.first).to be_a Project
    end
  end
end
