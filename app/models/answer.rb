class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  scope :sort_by_best, -> { order(:better, created_at: :desc).reverse }

  def set_better
    ActiveRecord::Base.transaction do
      question.delete_better if question.has_better_answer?
      self.update(better: true)
    end
  end

  def best?
    better
  end
end
