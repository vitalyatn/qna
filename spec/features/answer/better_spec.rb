require 'rails_helper'

feature 'User can choose better answer to question', %q{
  чтобы показать, что данный ответ решил его проблему
} do
  
  describe 'Authenticated user' do
    given!(:user) { create(:user) }
    given!(:question) { create(:question, user: user) }
    given!(:answers) {  create_list(:answer, 9, question: question) }
    background { sign_in(user) }

    describe 'is author of answer' do
      scenario 'can choose better answer', js: true do
        visit question_path(question)
        better_answer = answers[3]
        within "#answer-#{better_answer.id}" do
          click_on "Better"
        end
        within ".better_answer" do
          expect(page).to have_content better_answer.body
        end
      end

      scenario 'is not author of answer', js: true do
        question = create(:question, user: user)
        visit question_path(question)
        expect(page).to_not have_link 'Better'
      end
    end

    scenario 'Unauthenticated user tries add answer to question' do
      question = create(:question)
      visit question_path(question)
      expect(page).to_not have_link 'Better'
    end
  end

end