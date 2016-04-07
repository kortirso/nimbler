class WordSerializer < ActiveModel::Serializer
    attributes :id, :task_id, :name, :complete, :total_links, :total_results, :html_result

    class WithLinks < self
        has_many :links

        def links
            object.links.order(id: :asc)
        end
    end
end
