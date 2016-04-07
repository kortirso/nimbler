ThinkingSphinx::Index.define :task, with: :active_record do
    #fields
    indexes file
    indexes user.username, as: :author, sortable: true
    #attributes
    has user_id, created_at, updated_at   
end