class WordsController < ApplicationController
    before_filter :authenticate_user!
    before_action :find_word

    def show
        Launchy::Browser.run(@word.html_result)
        render nothing: true
    end

    private
    def find_word
        @word = Word.find(params[:id])
        render template: 'layouts/404', status: 404 if @word.nil? || @word.task.user_id != current_user.id
    end
end
