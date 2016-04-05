require 'csv'

class Api::V1::TasksController < Api::V1::BaseController
    def index
        respond_with tasks: current_resource_owner.tasks
    end

    def show
        @task = current_resource_owner.tasks.find_by(id: params[:id])
        if @task.nil?
            render text: 'no access'
        else
            respond_with @task, serializer: TaskSerializer::WithWords
        end
    end

    def create
        @task = current_resource_owner.tasks.new
        file = File.new("#{Rails.root}/public/uploads/task/file/#{@task.id}/file.csv", 'w')
        file.puts params[:file_text]
        @task.file = file
        file.close
        @task.save!
        @task.create_words
        respond_with @task, serializer: TaskSerializer::WithWords
    end
end