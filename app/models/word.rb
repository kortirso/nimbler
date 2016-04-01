class Word < ActiveRecord::Base
    belongs_to :task

    validates :total_links, :total_results, :html_result, :task_id, presence: true
end
