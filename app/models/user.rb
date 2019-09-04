class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :questions
  has_many :answers

  def author?(resource)
    #насчет универсальности не знаю...если добавятся еще какие-то сущности
    # то придется сюда лезть и добавлять сущность? или это можно сделать как-то
    # универсальнее?
    (questions.include? resource) || (answers.include? resource)
  end

end
