require 'rails_helper'

feature 'User can edit his answet', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthorized user can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    describe 'is author' do
      background { sign_in(user) }

      scenario 'edit his answer', js: true do
        visit question_path(question)

        click_on 'Edit'

        within '.answers' do
          fill_in 'Your answer', with: 'edited answer'
          click_on 'Save'

          expect(page).to_not have_content answer.body
          expect(page).to have_content 'edited answer'
          expect(page).to_not have_selector 'textarea'
        end
      end

      scenario 'edit his answer with errors', js: true do
        visit question_path(question)

        click_on 'Edit'

        within '.answers' do
          fill_in 'Your answer', with: ''
          click_on 'Save'
        end
        expect(page).to have_content answer.body
        expect(page).to have_content 'error'
      end

      scenario 'edit answer with attached file', js: true do
        visit question_path(question)

        click_on 'Edit'

        within '.answers' do
          fill_in 'Your answer', with: 'edited answer'
          attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Save'
        end
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario "tries to edit other user's answer", js: true do
      user = create(:user)
      sign_in(user)

      expect(page).to_not have_link 'Edit'
    end
  end

end