require 'csv'

class Task < ActiveRecord::Base
    belongs_to :user
    has_many :words

    mount_uploader :file, FileUploader

    validates :file, :user_id, presence: true

    def self.create_by_api(user_id, file_text)
        user = User.find(user_id)
        task = user.tasks.new
        file = File.new("#{Rails.root}/public/uploads/task/file/#{task.id}/file.csv", 'w')
        file.puts file_text
        task.file = file
        file.close
        task.save!
        task
    end

    def create_words
        CSV.read("#{Rails.root}/public#{self.file}", encoding: 'utf-8', col_sep: ';')[0..-1].each do |rows|
            rows.each { |row| self.words.create(name: row.to_s) }
        end
        ParsingTaskJob.perform_later(self)
    end
end
