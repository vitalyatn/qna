require 'rails_helper'

feature 'User can edit his question', %q{
  чтобы исправить свои ошибки в вопросе
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Unauthorized user can not edit question' do
    visit questions_path
    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    scenario 'edit his question', js: true do
      sign_in(user)

      click_on 'Edit'

      within '.questions' do
        fill_in "Question's title", with: 'edited title'
        fill_in 'Your question', with: 'edited question'
        click_on 'Save'

        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited title'
        expect(page).to_not have_selector 'textarea'

        #visit question_path(question)
        #Хотел зайти на страницу вопроса и убедиться что
        #вопрос был полностью изменен, но ошибка:
        #  Selenium::WebDriver::Error::StaleElementReferenceError:
        #        stale element reference: element is not attached to the page document
        #          (Session info: headless chrome=76.0.3809.132)
        # или это делать вообще не нужно?
        #expect(page).to have_content 'edited title'
        #expect(page).to have_content 'edited question'
      end
    end

    scenario 'edit his answer with errors', js: true do
      sign_in(user)

      click_on 'Edit'

      within '.questions' do
        fill_in "Question's title", with: ''
        fill_in 'Your question', with: ''
        click_on 'Save'

        expect(page).to have_content question.body
        expect(page).to have_content 'error'
      end
    end

    scenario "tries to edit other user's answer", js: true do
      user = create(:user)
      sign_in(user)

      expect(page).to_not have_link 'Edit'
    end

  end
end