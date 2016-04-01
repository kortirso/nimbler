class Task < ActiveRecord::Base
    belongs_to :user
    has_many :words

    mount_uploader :file, FileUploader

    validates :file, :user_id, presence: true
end
