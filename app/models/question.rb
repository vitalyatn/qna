class Question < ApplicationRecord
  has_many :answers, -> { order(better: :desc, created_at: :asc) }, dependent: :destroy
  belongs_to :user

  has_many_attached :files

  validates :title, :body, presence: true

end
