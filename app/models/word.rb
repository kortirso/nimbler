class Word < ActiveRecord::Base
    belongs_to :task

    validates :name, :task_id, presence: true

    scope :completed, -> { where complete: true }
    scope :active, -> { where complete: false }

    after_create :parsing_word

    private
    def parsing_word
        ParsingWordJob.perform_later(self)
    end
end
