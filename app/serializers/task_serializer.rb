class TaskSerializer < ActiveModel::Serializer
    attributes :id, :file

    class WithWords < self
        has_many :words, serializer: WordSerializer::WithLinks

        def words
            object.words.order(id: :asc)
        end
    end
end
