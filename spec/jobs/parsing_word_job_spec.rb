RSpec.describe ParsingWordJob, type: :job do
    let(:task) { create :task }
    let(:word) { create :word, task: task }

    it 'should complete word parsing' do
        ParsingWordJob.perform_now(word)

        expect(word.complete).to eq true
    end
end
