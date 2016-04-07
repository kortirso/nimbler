RSpec.describe SearchController, type: :controller do
    describe 'GET #find' do
        it 'renders find template' do
            get :find, search: { query: 'worldoftanks', options: 1}

            expect(response).to render_template 'search/find'
        end
    end
end