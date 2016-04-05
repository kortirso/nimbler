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
        @task = Task.create_by_api(current_resource_owner.id, params[:file_text])
        @task.create_words
        respond_with @task, serializer: TaskSerializer::WithWords
    end
end