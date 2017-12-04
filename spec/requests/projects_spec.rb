require 'rails_helper'

RSpec.describe "Projects", type: :request do

  let(:valid_attributes) { FactoryBot.build(:project).attributes }
  let(:invalid_attributes) { {name: ''} }
  context 'Logged In' do
    before do
      @user = FactoryBot.create(:user, password: 'password')
      post '/login', params: { email: @user.email, password: 'password' }
    end
    describe 'GET #index' do
      it 'returns a success response' do
        get projects_path
        expect(response).to be_success
      end
    end
    describe 'GET #show' do
      it 'returns a success response' do
        project = FactoryBot.create(:project, user: @user)
        get project_path(project)
        expect(response).to be_success
      end
    end
    describe 'GET #new' do
      it 'returns a success response' do
        get new_project_path
        expect(response).to be_success
      end
    end
    describe 'GET #edit' do
      it 'returns a success response' do
        project = FactoryBot.create(:project, user: @user)
        get edit_project_path(project)
        expect(response).to be_success
      end
    end
    describe 'Post #create' do
      context 'with valid params' do
        it 'creates a new project' do
          expect {
            post projects_path params: { project: valid_attributes }
          }.to change(Project, :count).by 1
        end
        it 'creates a new project owned by current_user' do
          post projects_path params: { project: valid_attributes }
          expect(Project.last.user).to eq @user
        end
        it 'redirects to the created context' do
          post projects_path params: { project: valid_attributes }
          expect(response).to redirect_to(Project.last)
        end
      end
      context 'with invalid praams' do
        it 'returns success response (i.e. to display the "new" template)' do
          post projects_path params: { project: invalid_attributes }
          expect(response).to be_success
        end
        it 'does not create a project' do
          expect {
            post projects_path params: { project: invalid_attributes }
          }.to_not change(Project, :count)
        end
      end
    end
    describe 'Put #update' do
      before do
        @project = FactoryBot.create(:project, user: @user)
      end
      context 'with valid params' do
        let(:new_attributes) { FactoryBot.build(:project, user: @user).attributes }
        it 'updates the requested project' do
          expect {
            put project_path(@project), params: { project: new_attributes }
          }.to change {
            @project.reload
            @project.name
          }
        end
        it 'redirects to the project' do
          put project_path(@project), params: { project: new_attributes }
          expect(response).to redirect_to(@project)
        end
        describe 'owned by different user' do
          before do
            @project = FactoryBot.create(:project)
          end
          it 'should not update the project' do
            expect(@project.user).to_not eq @user #sanity check
            expect {
              put project_path(@project), params: {project: new_attributes}
            }.to_not change{
              @project.reload
              @project.name
            }
          end
        end
      end
      context 'with new userid' do
        let(:new_attributes) { {user_id: FactoryBot.create(:user).id} }
        it 'should not change the user' do
          expect {
            put project_path(@project), params: {project: new_attributes}
          }.to_not change {
            @project.reload
            @project.user
          }
        end
        it 'should redirect to the project' do
          put project_path(@project), params: {project: new_attributes}
          expect(response).to redirect_to(@project)
        end
      end
      context 'with invalid params' do
        it 'should not change project' do
          expect{
            put project_path(@project), params: {project: invalid_attributes}
          }.to_not change {
            @project.reload
            @project.name
          }
        end
        it 'should return a success response (i.e. to display the "edit" template)' do
          put project_path(@project), params: {project: invalid_attributes}
          expect(response).to be_success
        end
      end
    end
    describe 'DELETE #destroy' do
      before do
        @project = FactoryBot.create(:project, user: @user)
      end
      it 'should destroy the requested project' do
        expect {
          delete project_path(@project)
        }.to change(Project, :count).by -1
      end
      it 'redirects to projects list' do
        delete project_path(@project)
        expect(response).to redirect_to(projects_path)
      end
      context 'owned by different user' do
        before do
          @project = FactoryBot.create(:project)
        end
        it 'should not destroy the project' do
          expect(@project.user).to_not eq @user # Sanity Check
          expect {
            delete project_path(@project)
          }.to_not change(Project, :count)
        end
      end
    end
  end
end
