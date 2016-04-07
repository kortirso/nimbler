RSpec.describe TasksController, type: :controller do
    describe 'GET #index' do
        context 'Unauthorized user' do
            it 'redirects to login page' do
                get :index

                expect(response).to redirect_to new_user_session_path
            end
        end

        context 'Authorized user' do
            sign_in_user

            it 'assigns the requested users tasks to @tasks' do
                get :index

                expect(assigns(:tasks)).to eq @current_user.tasks
            end

            it 'and render index view' do
                get :index

                expect(response).to render_template :index
            end
        end
    end

    describe 'GET #show' do
        let!(:task) { create :task }

        context 'Unauthorized user' do
            it 'redirects to login page' do
                get :show, id: task.id

                expect(response).to redirect_to new_user_session_path
            end
        end

        context 'Authorized user' do
            sign_in_user
            let!(:user_task) { create :task, user: @current_user }

            context 'when try to get access to his task' do
                it 'assigns the requested task to @task' do
                    get :show, id: user_task.id

                    expect(assigns(:task)).to eq user_task
                end

                it 'assigns the words in task to @words' do
                    get :show, id: user_task.id

                    expect(assigns(:words)).to eq user_task.words
                end

                it 'and render show view' do
                    get :show, id: user_task.id

                    expect(response).to render_template :show
                end
            end

            context 'when try to get access to task of another user' do
                it 'redirects to error page' do
                    get :show, id: task.id

                    expect(response).to render_template 'layouts/404'
                end
            end
        end
    end

    describe 'POST #create' do
        context 'Unauthorized user' do
            it 'cant create task' do
                expect { post :create, task: { file: File.open(File.join(Rails.root, 'db/simple_test_data.csv')) }, format: :js }.to_not change(Task, :count)
            end
        end

        context 'Authorized user' do
            sign_in_user

            it 'can create task' do
                expect { post :create, task: { file: File.open(File.join(Rails.root, 'db/simple_test_data.csv')) }, format: :js }.to change(Task, :count).by(1)
            end

            it 'and creates words' do
                expect { post :create, task: { file: File.open(File.join(Rails.root, 'db/simple_test_data.csv')) }, format: :js }.to change(Word, :count)
            end

            it 'and redirected to tasks' do
                post :create, task: { file: File.open(File.join(Rails.root, 'db/simple_test_data.csv')) }, format: :js

                expect(response).to redirect_to tasks_path
            end
        end
    end
end
