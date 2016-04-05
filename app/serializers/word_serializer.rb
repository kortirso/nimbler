class WordSerializer < ActiveModel::Serializer
    attributes :id, :task_id, :name, :complete, :total_links, :total_results, :html_result
end
