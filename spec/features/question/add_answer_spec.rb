require 'rails_helper'

feature 'User can add answer to question', %q{
  чтобы предложить свой вариант решения проблемы
  пользователь должен быть зарегистрирован
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    background { sign_in(user) }

    scenario 'add answer to question' do
      visit question_path(question)
      fill_in 'Body', with: 'text text text'
      click_on 'Add answer'

      expect(page).to have_content 'Your answer successfully created'
      expect(page).to have_content 'text text text'
    end

    scenario 'add answer to question with errors' do
      visit question_path(question)
      click_on 'Add answer'
      #save_and_open_page
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries add answer to question' do
    visit question_path(question)
    expect(page).to have_no_content 'Add answer'
  end

end