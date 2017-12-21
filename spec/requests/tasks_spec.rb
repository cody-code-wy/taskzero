require 'rails_helper'

RSpec.describe "Tasks", type: :request do

  let(:valid_attributes) { FactoryBot.attributes_for(:task, user: nil) }
  let(:invalid_attributes) { {name: ''} }
  context 'Logged In' do
    before do
      @user = FactoryBot.create(:user, password: 'password')
      post '/login', params: { email: @user.email, password: 'password' }
    end
    describe 'GET #index' do
      it 'returns a success response' do
        get tasks_path
        expect(response).to be_success
      end
    end
    describe 'Get #show' do
      it 'returns a success response' do
        task = FactoryBot.create(:task, user: @user)
        get task_path(task)
        expect(response).to be_success
      end
    end
    describe 'Get #new' do
      it 'returns a success response' do
        get new_task_path
        expect(response).to be_success
      end
    end
    describe 'get #edit' do
      it 'returns a success response' do
        task = FactoryBot.create(:task, user: @user)
        get edit_task_path(task)
        expect(response).to be_success
      end
    end
    describe 'post #create' do
      context 'with valid params' do
        it 'creates a new task' do
          expect {
            post tasks_path params: { task: valid_attributes }
          }.to change(Task, :count).by 1
        end
        it 'creates a new task owned by current_user' do
          post tasks_path params: { task: valid_attributes }
          expect(Task.last.user).to eq @user
        end
        it 'redirects to the created task' do
          post tasks_path params: { task: valid_attributes }
          expect(response).to redirect_to(Task.last)
        end
      end
      context 'with invalid params' do
        it 'returns success response (i.e. to display the "new" template)' do
          post tasks_path params: { task: invalid_attributes }
          expect(response).to be_success
        end
        it 'does not create a Task' do
          expect {
            post tasks_path params: { task: invalid_attributes }
          }.to_not change(Task, :count)
        end
      end
    end
    describe 'Put #update' do
      before do
        @task = FactoryBot.create(:task, user: @user)
      end
      context 'with valid params' do
        let(:new_attributes) { FactoryBot.attributes_for(:task, user: nil) }
        it 'updates the requested task' do
          expect {
            put task_path(@task), params: { task: valid_attributes }
          }.to change{
            @task.reload
            @task.name
          }
        end
        it 'redirects to the task' do
          put task_path(@task), params: { task: new_attributes }
          expect(response).to redirect_to(@task)
        end
        describe 'owned by different user' do
          before do
            @task = FactoryBot.create(:task)
          end
          it 'should not update the task' do
            expect(@task.user).to_not eq @user #sanity check
            expect {
              put task_path(@task), params: { task: new_attributes }
            }.to_not change {
              @task.reload
              @task.name
            }
          end
        end
      end
      context 'with new userid' do
        let(:new_attributes) { {user_id: FactoryBot.create(:user).id} }
        it 'should not change the user' do
          expect {
            put task_path(@task), params: {task: new_attributes}
          }.to_not change {
            @task.reload
            @task.user
          }
        end
        it 'should redirect to the task' do
          put task_path(@task), params: {task: new_attributes}
          expect(response).to redirect_to(@task)
        end
      end
      context 'with invalid params' do
        it 'should not change task' do
          expect {
            put task_path(@task), params: {task: invalid_attributes}
          }.to_not change {
            @task.reload
            @task.name
          }
        end
        it 'should return a succoss response (i.e. to display the "edit" template)' do
          put task_path(@task), params: {task: invalid_attributes}
          expect(response).to be_success
        end
      end
    end
    describe 'DELETE #destroy' do
      before do
        @task = FactoryBot.create(:task, user: @user)
      end
      it 'should destroy the requested task' do
        expect {
          delete task_path(@task)
        }.to change(Task, :count).by -1
      end
      it 'redirects to task list' do
        delete task_path(@task)
        expect(response).to redirect_to(tasks_path)
      end
      context 'owned by different user' do
        before do
          @task = FactoryBot.create(:task)
        end
        it 'should not destroy the task' do
          expect(@task.user).to_not eq @user #Sanity Check
          expect {
            delete task_path(@task)
          }.to_not change(Task, :count)
        end
      end
    end
  end
end
