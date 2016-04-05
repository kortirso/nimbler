describe 'Task API' do
    describe 'GET /index' do
        let!(:me) { create :user }
        let!(:task) { create :task, user_id: me.id }

        it_behaves_like 'API Authenticable'

        context 'authorized' do
            let!(:access_token) { create :access_token, resource_owner_id: me.id }

            before { get '/api/v1/tasks', format: :json, access_token: access_token.token }

            it 'returns 200 status' do
                expect(response).to be_success
            end

            it 'contains list of user tasks' do
                expect(response.body).to be_json_eql(task.to_json).at_path('tasks/0')
            end
        end

        def do_request(options = {})
            get '/api/v1/tasks', { format: :json }.merge(options)
        end
    end

    describe 'GET /show' do
        let!(:me) { create :user }
        let!(:task) { create :task, user_id: me.id }
        let!(:word) { create :word, task: task }
        let!(:another_tasks) { create :task }

        it_behaves_like 'API Authenticable'

        context 'authorized' do
            let!(:access_token) { create :access_token, resource_owner_id: me.id }

            before { get "/api/v1/tasks/#{task.id}", format: :json, access_token: access_token.token }

            it 'returns 200 status' do
                expect(response).to be_success
            end

            it 'returns 200 status with nul if try access to another_tasks' do
                get "/api/v1/tasks/#{another_tasks.id}", format: :json, access_token: access_token.token

                expect(response).to be_success
                expect(response.body).to eq 'no access'
            end

            %w(id file).each do |attr|
                it "contains #{attr}" do
                    expect(response.body).to be_json_eql(task.send(attr.to_sym).to_json).at_path("with_words/#{attr}")
                end
            end

            context 'words' do
                it 'included in task object' do
                    expect(response.body).to have_json_size(1).at_path("with_words/words")
                end

                %w(id task_id name complete total_links total_results html_result).each do |attr|
                    it "contains #{attr}" do
                        expect(response.body).to be_json_eql(word.send(attr.to_sym).to_json).at_path("with_words/words/0/#{attr}")
                    end
                end
            end
        end

        def do_request(options = {})
            get "/api/v1/tasks/#{task.id}", { format: :json }.merge(options)
        end
    end

    describe 'POST /create' do
        let!(:me) { create :user }
        let!(:access_token) { create :access_token, resource_owner_id: me.id }

        it_behaves_like 'API Authenticable'

        context 'authorized' do
            context 'with valid attributes' do
                it 'returns 200 status code' do
                    post '/api/v1/tasks', file_text: 'first', format: :json, access_token: access_token.token

                    expect(response).to be_success
                end

                it 'saves the new task in the DB' do
                    expect { post '/api/v1/tasks', file_text: 'first', format: :json, access_token: access_token.token }.to change(Task, :count).by(1)
                end

                it 'saves the new words in the DB' do
                    expect { post '/api/v1/tasks', file_text: 'first;second', format: :json, access_token: access_token.token }.to change(Word, :count).by(2)
                end
            end

            context 'words' do
                before { post '/api/v1/tasks', file_text: 'first;second', format: :json, access_token: access_token.token }

                it 'included in task object' do
                    expect(response.body).to have_json_size(2).at_path("with_words/words")
                end

                %w(id task_id name complete total_links total_results html_result).each do |attr|
                    it "contains #{attr}" do
                        expect(response.body).to be_json_eql(Task.last.words.order(id: :asc).first.send(attr.to_sym).to_json).at_path("with_words/words/0/#{attr}")
                    end
                end
            end
        end

        def do_request(options = {})
            post '/api/v1/tasks', { file_text: 'first', format: :json }.merge(options)
        end
    end
end