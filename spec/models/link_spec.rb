RSpec.describe Link, type: :model do
    it { should belong_to :word}
    it { should validate_presence_of :type }
    it { should validate_presence_of :name }
    it { should validate_presence_of :word_id }
    it { should validate_inclusion_of(:type).in_array(%w(none top right)) }
end
