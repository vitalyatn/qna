require 'rails_helper'

feature 'User can see list of questions', %q{
  чтобы попытаться найти в этом списке,
  похожий вопрос который решит проблему пользователя
} do

  scenario 'show list of questions' do
    create_list(:question, 3)
    visit questions_path
    expect(page).to have_content 'MyString'
  end

end