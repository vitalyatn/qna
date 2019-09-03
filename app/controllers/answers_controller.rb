class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[create]
  before_action :set_answer, only: %i[destroy show]

  def show
  end

  def new
  end

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      redirect_to @answer.question, notice: 'Your answer successfully created'
    else
      render 'questions/show', locals: { question: @question }
    end
  end

  def destroy
    @answer.destroy if user_signed_in? && current_user.author?(@answer)
    redirect_to question_path(@answer.question)
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
