RSpec.describe WordsController, type: :controller do
    describe 'GET #show' do
        let!(:word) { create :word }

        context 'Unauthorized user' do
            it 'redirects to login page' do
                get :show, id: word.id

                expect(response).to redirect_to new_user_session_path
            end
        end

        context 'Authorized user' do
            sign_in_user

            context 'when try to get access to task of another user' do
                it 'redirects to error page' do
                    get :show, id: word.id

                    expect(response).to render_template 'layouts/404'
                end
            end
        end
    end
end
