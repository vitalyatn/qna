class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def index
    @questions = Question.all
  end

  def show
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created'
    else
      render :new
    end
  end

  def new
  end

  def update
    #byebug
    if current_user&.author?(question)
      if question.update(question_params)
        redirect_to @question
      else
        render :edit
      end
    end
  end

  def edit
  end

  def destroy
    question.destroy if current_user&.author?(question)
    redirect_to questions_path
  end

  private

  def question
    @question ||= params[:id] ? Question.find(params[:id]) : Question.new
  end

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
