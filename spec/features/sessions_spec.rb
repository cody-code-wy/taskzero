require 'rails_helper'

RSpec.feature "Sessions", type: :feature do
  describe 'logged in' do
    before do
      @password = Faker::Internet.password(8)
      @user = FactoryBot.create(:user, password: @password, password_confirmation: @password)
      visit '/login'
      fill_in 'email', with: @user.email
      fill_in 'password', with: @password
      click_button 'Log In'
    end
    it 'should display the user\'s name' do
      expect(page).to have_content @user.first_name
    end
    it 'should have the logout button' do
      expect(page).to have_content 'Logout'
    end
    it 'sholud not have login or signup buttons' do
      expect(page).to_not have_selector '#user_header .sign_up'
      expect(page).to_not have_selector '#user_header .log_in'
    end
    it 'should not allow them to access user#new' do
      visit new_user_path
      expect(current_path).to eq '/'
    end
    it 'should not allow them to access user#create' do
      page.driver.post(user_path)
      expect(current_path).to eq user_path
    end
  end
  describe 'logged out' do
    it 'should have greeter' do
      visit '/'
      expect(page).to have_content("Sign Up, or Login to get started")
      expect(page).to have_css(".header #user_header .greeter")
    end
    it 'should have a login button' do
      visit '/'
      expect(page).to have_content("Log In")
      expect(page).to have_css('.header #user_header .log_in')
    end
    it 'should have a sign up button' do
      visit '/'
      expect(page).to have_content("Sign Up")
      expect(page).to have_css('.header #user_header .sign_up')
    end
  end
  describe 'loggin in' do
    context 'with valid login' do
      before do
        @password = Faker::Internet.password(8)
        @user = FactoryBot.create(:user, password: @password, password_confirmation: @password)
        visit '/'
        click_link 'Log In'
        fill_in 'email', with: @user.email
        fill_in 'password', with: @password
        click_button 'Log In'
      end
      it 'should allow the login' do
        expect(page).to have_content @user.first_name
      end
      it 'should redirect to /' do
        expect(current_path).to eq '/'
      end
      it 'should show flash[:notice]' do
        expect(page).to have_content "Welcome back #{@user.first_name}!"
      end
    end
    context 'with invalid login' do
      before do
        visit '/'
        click_link 'Log In'
        fill_in 'email', with: Faker::Internet.email
        fill_in 'password', with: Faker::Internet.password(8)
        click_button 'Log In'
      end
      it 'should indicate invalid email or password' do
        expect(page).to have_content 'Email or Password is Invalid'
      end
      it 'should be at /login' do
        expect(current_path).to eq '/login'
      end
      it 'should not be logged in' do
        expect(page).to_not have_content 'Logout'
      end
    end
  end
  describe 'signing up' do
    it 'should allow a logged out user to access user#new' do
      visit '/'
      click_link 'Sign Up'
      expect(current_path).to eq new_user_path
      expect(page.status_code).to eq 200 #:ok
    end
    context 'with valid parameters' do
      before do
        @user_template = FactoryBot.build(:user) #not saved to disk
        @password = Faker::Internet.password(8)
        visit '/'
        click_link 'Sign Up'
        fill_in 'user_first_name', with: @user_template.first_name
        fill_in 'user_last_name', with: @user_template.last_name
        fill_in 'user_email', with: @user_template.email
        fill_in 'user_password', with: @password
        fill_in 'user_password_confirmation', with: @password
      end
      it 'should create a matching user' do
        expect {
          click_button 'Create User'
          expect(page.status_code).to eq 200 #:ok
        }.to change { User.all.count }.by 1
        @user = User.find_by_email(@user_template.email) #Get the user!
        expect(@user.first_name).to eq @user_template.first_name
        expect(@user.last_name).to eq @user_template.last_name
        expect(@user.email).to eq @user_template.email
        expect(@user.authenticate(@password)).to be_truthy
      end
      it 'should automaticall log in the new user' do
        click_button 'Create User'
        expect(page).to have_content @user_template.first_name
        expect(page).to have_selector '#user_header .logout'
      end
      it 'should redirect to /' do
        click_button 'Create User'
        expect(current_path).to eq '/'
      end
      it 'should show flash[:notice]' do
        click_button 'Create User'
        expect(page).to have_content 'Thank you for signing up for Task Zero!'
      end
    end
    context 'with invalid parameters' do
      before do
        @user_template = FactoryBot.build(:user) #not saved to disk
        @password = Faker::Internet.password(8)
        visit '/'
        click_link 'Sign Up'
        #Fill all fields with valid data
        fill_in 'user_first_name', with: @user_template.first_name
        fill_in 'user_last_name', with: @user_template.last_name
        fill_in 'user_email', with: @user_template.email
        fill_in 'user_password', with: @password
        fill_in 'user_password_confirmation', with: @password
      end
      context 'missing first name' do
        before do
          fill_in 'user_first_name', with: nil
        end
        it 'should not create the user' do
          expect {
            click_button 'Create User'
            expect(page.status_code).to eq 200 #:ok
            expect(current_path).to eq user_path
            expect(page).to have_content 'New User'
          }.to_not change { User.all.count }
        end
        it 'should indicate first name is missing' do
          click_button 'Create User'
          expect(page).to have_content 'First name can\'t be blank'
          expect(page).to have_selector '.field_with_errors label[for="user_first_name"]'
          expect(page).to have_selector '.field_with_errors input#user_first_name'
        end
      end
      context 'missing last name' do
        before do
          fill_in 'user_last_name', with: nil
        end
        it 'should not create the user' do
          expect {
            click_button 'Create User'
            expect(page.status_code).to eq 200 #:ok
            expect(current_path).to eq user_path
            expect(page).to have_content 'New User'
          }.to_not change { User.all.count }
        end
        it 'should indicate last name is missing' do
          click_button 'Create User'
          expect(page).to have_content 'Last name can\'t be blank'
          expect(page).to have_selector '.field_with_errors label[for="user_last_name"]'
          expect(page).to have_selector '.field_with_errors input#user_last_name'
        end
      end
      context 'missing email' do
        before do
          fill_in 'user_email', with: nil
        end
        it 'should not create the user' do
          expect {
            click_button 'Create User'
            expect(page.status_code).to eq 200 #:ok
            expect(current_path).to eq user_path
            expect(page).to have_content 'New User'
          }.to_not change { User.all.count }
        end
        it 'should indicate the email is missing' do
          click_button 'Create User'
          expect(page).to have_content 'Email can\'t be blank'
          expect(page).to have_selector '.field_with_errors label[for="user_email"]'
          expect(page).to have_selector '.field_with_errors input#user_email'
        end
      end
      context 'malformed email' do
        before do
          fill_in 'user_email', with: 'Not an email'
        end
        it 'should not create the user' do
          expect {
            click_button 'Create User'
            expect(page.status_code).to eq 200 #:ok
            expect(current_path).to eq user_path
            expect(page).to have_content 'New User'
          }.to_not change { User.all.count }
        end
        it 'should indicate the email is invalid' do
          click_button 'Create User'
          expect(page).to have_content 'Email Invalid Email Address'
          expect(page).to have_selector '.field_with_errors label[for="user_email"]'
          expect(page).to have_selector '.field_with_errors input#user_email'
        end
      end
      context 'missing password' do
        before do
          fill_in 'user_password', with: nil
          fill_in 'user_password_confirmation', with: nil
        end
        it 'should not create the user' do
          expect {
            click_button 'Create User'
            expect(page.status_code).to eq 200 #:ok
            expect(current_path).to eq user_path
            expect(page).to have_content 'New User'
          }.to_not change { User.all.count }
        end
        it 'should indicate the password is missing' do
          click_button 'Create User'
          expect(page).to have_content 'Password can\'t be blank'
          expect(page).to have_selector '.field_with_errors label[for="user_password"]'
          expect(page).to have_selector '.field_with_errors input#user_password'
        end
      end
      context 'short password' do
        before do
          @password = Faker::Internet.password(1,7) #short password
          fill_in 'user_password', with: @password
          fill_in 'user_password_confirmation', with: @password
        end
        it 'should not create the user' do
          expect {
            click_button 'Create User'
            expect(page.status_code).to eq 200 #:ok
            expect(current_path).to eq user_path
            expect(page).to have_content 'New User'
          }.to_not change { User.all.count }
        end
        it 'should indicate the password is to short' do
          click_button 'Create User'
          expect(page).to have_content 'Password is too short (minimum is 8 characters)'
          expect(page).to have_selector '.field_with_errors label[for="user_password"]'
          expect(page).to have_selector '.field_with_errors input#user_password'
        end
      end
      context 'non matching password confirmation' do
        before do
          fill_in 'user_password_confirmation', with: Faker::Internet.password(8)
        end
        it 'should not create the user' do
          expect {
            click_button 'Create User'
            expect(page.status_code).to eq 200 #:ok
            expect(current_path).to eq user_path
            expect(page).to have_content 'New User'
          }.to_not change { User.all.count }
        end
        it 'should indicate the password is not matching' do
          click_button 'Create User'
          expect(page).to have_content 'Password confirmation doesn\'t match Password'
          expect(page).to have_selector '.field_with_errors label[for="user_password_confirmation"]'
          expect(page).to have_selector '.field_with_errors input#user_password_confirmation'
        end
        # it 'should indicate the password is not matching usig JS', js: true
      end
    end
  end
  describe 'logging out' do
    context 'from logged in' do
      before do
        @password = Faker::Internet.password(8)
        @user = FactoryBot.create(:user, password: @password, password_confirmation: @password)
        visit '/login'
        fill_in 'email', with: @user.email
        fill_in 'password', with: @password
        click_button 'Log In'
        expect(page).to have_content @user.first_name
        visit '/logout'
      end
      it 'should log out user' do
        expect(page).to_not have_content @user.first_name
      end
      it 'should redirect to /' do
        expect(current_path).to eq '/'
      end
    end
    context 'from logged out' do
      it 'should still be logged out' do
        visit '/logout'
        expect(page).to have_content 'Log In'
        expect(page).to have_content 'Sign Up'
      end
      it 'should redirect to /' do
        visit '/logout'
        expect(current_path).to eq '/'
      end
    end
  end
end
