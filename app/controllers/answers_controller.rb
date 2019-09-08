class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[create]
  before_action :set_answer, only: %i[destroy show update better]

  def show
  end

  def new
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def destroy
    @answer.destroy if current_user&.author?(@answer)
  end

  def better
    if @answer.question.has_better_answer?
      @answer.question.delete_better
      @answer.update(better: true)
    else
      @answer.update(better: true)
    end
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, :better)
  end
end
