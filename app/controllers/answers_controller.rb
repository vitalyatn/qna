class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[create]
  before_action :set_answer, only: %i[destroy show update better]
  before_action :author?, only: %i[update destroy]

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
    @answer.destroy
  end

  def better
    #byebug
    @answer.set_better! if current_user&.author?(@answer.question)
  end

  private
  def author?
    redirect_to questions_path unless current_user&.author?(@answer)
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
