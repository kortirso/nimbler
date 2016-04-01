require 'csv'

class Task < ActiveRecord::Base
    belongs_to :user
    has_many :words

    mount_uploader :file, FileUploader

    validates :file, :user_id, presence: true

    def create_words
        CSV.read("#{Rails.root}/public#{self.file}", encoding: 'utf-8', col_sep: ';')[0..-1].each do |rows|
            rows.each { |row| self.words.create(name: row.to_s) }
        end
    end
end
