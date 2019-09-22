require 'rails_helper'

feature 'User can add answer to question', %q{
  чтобы предложить свой вариант решения проблемы
  пользователь должен быть зарегистрирован
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    background { sign_in(user) }

    scenario 'add answer to question', js: true  do
      visit question_path(question)
      fill_in 'Body', with: 'text text text'
      click_on 'Add answer'

      expect(page).to have_content 'text text text'
    end

    scenario 'add answer to question with errors', js: true do
      visit question_path(question)
      click_on 'Add answer'
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'add answer with attached file', js: true  do
      visit question_path(question)
      click_on 'Add answer'
      fill_in 'Body', with: 'text text text'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Add answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Unauthenticated user tries add answer to question' do
    visit question_path(question)
    expect(page).to have_no_content 'Add answer'
  end

end