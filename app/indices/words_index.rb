ThinkingSphinx::Index.define :word, with: :active_record do
    #fields
    indexes name, sortable: true
    indexes total_links
    indexes total_results
    #attributes
    has task_id, created_at, updated_at   
end