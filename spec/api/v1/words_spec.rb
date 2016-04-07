describe 'Word API' do
    describe 'GET /show' do
        let!(:me) { create :user }
        let!(:task) { create :task, user_id: me.id }
        let!(:word) { create :word, task: task }
        let!(:link) { create :link, word: word }
        let!(:another_tasks) { create :task }
        let!(:another_word) { create :word, task: another_tasks }

        it_behaves_like 'API Authenticable'

        context 'authorized' do
            let!(:access_token) { create :access_token, resource_owner_id: me.id }

            before { get "/api/v1/words/#{word.id}", format: :json, access_token: access_token.token }

            it 'returns 200 status' do
                expect(response).to be_success
            end

            it 'returns 200 status with nul if try access to another_word' do
                get "/api/v1/words/#{another_word.id}", format: :json, access_token: access_token.token

                expect(response).to be_success
                expect(response.body).to eq 'no access'
            end

            %w(id task_id name complete total_links total_results html_result).each do |attr|
                it "contains #{attr}" do
                    expect(response.body).to be_json_eql(word.send(attr.to_sym).to_json).at_path("with_links/#{attr}")
                end
            end

            context 'links' do
                it 'included in word object' do
                    expect(response.body).to have_json_size(1).at_path("with_links/links")
                end

                %w(id name type).each do |attr|
                    it "contains #{attr}" do
                        expect(response.body).to be_json_eql(link.send(attr.to_sym).to_json).at_path("with_links/links/0/#{attr}")
                    end
                end
            end
        end

        def do_request(options = {})
            get "/api/v1/words/#{word.id}", { format: :json }.merge(options)
        end
    end
end