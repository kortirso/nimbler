RSpec.describe Word, type: :model do
    it { should belong_to :task }
    it { should have_many :links }
    it { should validate_presence_of :task_id }
    it { should validate_presence_of :name }

    describe '.parsing_word' do
        let(:task) { create :task }
        subject { build :word, task: task }

        it 'should perform_later job' do
            skip 'remove method'
            expect(ParsingWordJob).to receive(:perform_later).with(subject)
            subject.save!
        end
    end
end
