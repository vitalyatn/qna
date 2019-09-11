class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :author?, only: %i[update destroy]
  before_action :all_questions, only: %i[index update]

  def index
  end

  def show
    @answer = Answer.new
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created'
    else
      render :new
    end
  end

  def new; end

  def update
    question.update(question_params)
  end

  def edit; end

  def destroy
    question.destroy
    redirect_to questions_path
  end

  private

  def question
    @question ||= params[:id] ? Question.find(params[:id]) : Question.new
  end

  def author?
    redirect_to questions_path unless current_user&.author?(question)
  end

  def all_questions
    @questions = Question.all
  end

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
