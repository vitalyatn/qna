class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  def set_better
    transaction do
      question.answers.find_by(better: true)&.update!(better: false)
      update!(better: true)
    end
  end
end
