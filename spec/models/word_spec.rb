RSpec.describe Word, type: :model do
    it { should belong_to :task }
    it { should validate_presence_of :task_id }
    it { should validate_presence_of :total_links }
    it { should validate_presence_of :total_results }
    it { should validate_presence_of :html_result }
end
