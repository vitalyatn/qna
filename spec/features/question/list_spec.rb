require 'rails_helper'

feature 'User can see list of questions', %q{
  чтобы попытаться найти в этом списке,
  похожий вопрос который решит проблему пользователя
} do

  scenario 'show list of questions' do
    visit questions_path
    have_content "Title"
  end

end