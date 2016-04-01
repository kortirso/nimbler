class WelcomeController < ApplicationController
    def index
        redirect_to tasks_path if current_user
    end
end