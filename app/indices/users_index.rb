ThinkingSphinx::Index.define :user, with: :active_record do
    #fields
    indexes username
    #attributes
    has created_at, updated_at   
end