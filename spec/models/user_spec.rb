require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Factory' do
    it 'should have a valid factory' do
      expect(FactoryBot.build(:user)).to be_valid
    end
    it 'should have a valid factory with_tasks' do
      expect(FactoryBot.build(:user, :with_tasks)).to be_valid
    end
    it 'should have a valid factory with_projects' do
      expect(FactoryBot.build(:user, :with_projects)).to be_valid
    end
    it 'should have a valid factory with_contexts' do
      expect(FactoryBot.build(:user, :with_contexts)).to be_valid
      #also context there is a branch
      expect(FactoryBot.create(:user, :with_contexts)).to be_valid
    end
    it 'should have a valid factory with all traits' do
      expect(FactoryBot.build(:user, :with_tasks, :with_projects, :with_contexts)).to be_valid
    end
  end

  describe 'Validations' do
    it 'should be invalid without first_name' do
      expect(FactoryBot.build(:user, first_name: nil)).to_not be_valid
    end
    it 'should be invalid without last_name' do
      expect(FactoryBot.build(:user, last_name: nil)).to_not be_valid
    end
    it 'should be invalid without email' do
      expect(FactoryBot.build(:user, email: nil)).to_not be_valid
    end
    it 'should be invalid without password_digest' do
      expect(FactoryBot.build(:user, password_digest: nil)).to_not be_valid
    end
    it 'should be invalid with password shorter than 8 chars' do
      expect(FactoryBot.build(:user, password: '1234567', password_confirmation: '1234567')).to_not be_valid
    end
    it 'should be valid with password equal to or longer than 8 chars' do
      expect(FactoryBot.build(:user, password: '12345678', password_confirmation: '12345678')).to be_valid
    end
    it 'should be invalid with non-matching password and password_confirmation' do
      expect(FactoryBot.build(:user, password: '12345678', password_confirmation: '87654321')).to_not be_valid
    end
    it 'should be invalid with malformed email' do
      expect(FactoryBot.build(:user, email: 'not an email')).to_not be_valid
    end
    it 'should be invalid with duplicate email' do
      user = FactoryBot.create(:user)
      expect(FactoryBot.build(:user, email: user.email)).to_not be_valid
    end
    it 'should update without password and password confirmation' do
      user = FactoryBot.create(:user)
      expect { user.update(first_name: Faker::Name.first_name) }.to_not change { user.valid? }
    end
    it 'should be valid from db' do
      user = FactoryBot.create(:user)
      expect(User.find(user.id)).to be_valid
    end
    it 'should not have password from db' do
      user = FactoryBot.create(:user)
      expect(User.find(user.id).password).to be nil
    end
    it 'sholud not have password_confirmation from db' do
      user = FactoryBot.create(:user)
      expect(User.find(user.id).password_confirmation).to be nil
    end
  end

  describe 'Relations' do
    before do
      @user = FactoryBot.build(:user, :with_tasks, :with_projects, :with_contexts)
    end
    pending 'should have Tasks' do
      expect(@user.tasks.first).to be_a Task
    end
    it 'should have Projects' do
      expect(@user.projects.first).to be_a Project
    end
    it 'should have Contexts' do
      expect(@user.contexts.first).to be_a Context
    end
  end

  describe 'has_secure_password' do
    it 'should authenticate with correct password' do
      expect(FactoryBot.build(:user, password: '12345678', password_confirmation: '12345678').authenticate('12345678')).to be_truthy
    end
    it 'should not authenticate with incorrect password' do
      expect(FactoryBot.build(:user, password: '12345678', password_confirmation: '12345678').authenticate('87654321')).to be_falsy
    end
    it 'should change password_digest when updated with matching password and password_confirmation' do
      user = FactoryBot.create(:user, password: '12345678', password_confirmation: '12345678')
      expect { user.update(password: '87654321', password_confirmation: '87654321') }.to change { user.reload; user.password_digest }
    end
    it 'should not change password_digest when updated with non-matching password and password_confirmation' do
      user = FactoryBot.create(:user, password: '12345678', password_confirmation: '12345678')
      expect { user.update(password: '87654321', password_confirmation: '12345678') }.to_not change { user.reload; user.password_digest }
    end
    it 'should not change password_digest when updated with password less than 8 chars' do
      user = FactoryBot.create(:user, password: '12345678', password_confirmation: '12345678')
      expect { user.update(password: '7654321', password_confirmation: '7654321') }.to_not change { user.reload; user.password_digest }
    end
  end
end
