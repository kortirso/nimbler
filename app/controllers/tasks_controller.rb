class TasksController < ApplicationController
    before_filter :authenticate_user!

    def index
        @tasks = current_user.tasks.order(id: :desc)
    end

    def show
        @task = current_user.tasks.find(params[:id])
        @words = @task.words.order(name: :asc)
    end

    def create
        @task = current_user.tasks.create(tasks_params)
        @task.create_words
        redirect_to tasks_path
    end

    private
    def tasks_params
        params.require(:task).permit(:file)
    end
end
