class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user

  validates :title, :body, presence: true

  def has_better_answer?
    !get_better_answer.nil?
  end

  def delete_better
    get_better_answer.update(better: false)
  end
  
  def better_answer
    if get_better_answer.nil?
      ''
    else
      get_better_answer.body
    end
  end
  
  private
  
  def get_better_answer
    answers.select { |answer| answer.better == true }[0]
  end
end
