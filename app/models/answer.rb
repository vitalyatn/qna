class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  def user_author?(current_user)
    current_user == user
  end
end
