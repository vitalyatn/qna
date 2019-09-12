class Question < ApplicationRecord
  has_many :answers,-> { order(better: :desc, created_at: :asc) }, dependent: :destroy
  belongs_to :user

  validates :title, :body, presence: true

  def delete_better
    get_better_answer.update(better: false)
  end

  def better_answer
    get_better_answer[0] unless get_better_answer.nil?
  end

  private

  def get_better_answer
    answers.where(better: true)
  end
end
