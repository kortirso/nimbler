ThinkingSphinx::Index.define :link, with: :active_record do
    #fields
    indexes name, sortable: true
    indexes type
    #attributes
    has word_id, created_at, updated_at   
end