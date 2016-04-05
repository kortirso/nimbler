RSpec.describe Task, type: :model do
    it { should belong_to :user }
    it { should validate_presence_of :user_id }
    it { should validate_presence_of :file }

    context '.create_words' do
        let!(:task) { create :task, file: File.open(File.join(Rails.root, 'db/simple_test_data.csv')) }

        it 'should create words from file' do
            expect { task.create_words }.to change(task.words, :count).by(3)
        end

        it 'should activate perform_later job' do
            expect(ParsingTaskJob).to receive(:perform_later).with(task)
            task.create_words
        end
    end

    context 'self.create_by_api' do
        let!(:user) { create :user }
        let!(:file_text) { 'first;second' }

        it 'should create task and it should belong_to user' do
            expect { Task.create_by_api(user.id, file_text) }.to change(user.tasks, :count).by(1)
        end
    end
end
