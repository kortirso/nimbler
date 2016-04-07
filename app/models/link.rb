class Link < ActiveRecord::Base
    self.inheritance_column = nil
    
    belongs_to :word

    validates :type, :name, :word_id, presence: true
    validates :type, inclusion: { in: %w(none top right) }
end
