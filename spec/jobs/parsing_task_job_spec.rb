RSpec.describe ParsingTaskJob, type: :job do
    let(:task) { create :task }

    it 'should complete word parsing' do
        ParsingTaskJob.perform_now(task)

        task.words.each { |word| expect(word.complete).to eq true }
    end
end
