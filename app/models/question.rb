class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user

  validates :title, :body, presence: true

  def has_better_answer?
    !get_better_answer.empty?
  end

  def delete_better
    get_better_answer.update(better: false)
  end

  def better_answer
    get_better_answer[0] unless get_better_answer.nil?
  end

  def sort_answers
    answers.sort_by_best
  end

  private

  def get_better_answer
    answers.where(better: true)
  end
end
