RSpec.describe WelcomeController, type: :controller do
    describe 'GET #index' do
        context 'Unauthorized user' do
            it 'render index view' do
                get :index

                expect(response).to render_template :index
            end
        end

        context 'Authorized user' do
            sign_in_user

            it 'redirects to tasks' do
                get :index

                expect(response).to redirect_to tasks_path
            end
        end
    end
end