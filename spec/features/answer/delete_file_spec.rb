require 'rails_helper'

feature 'User can delete files from own answer', %q{
  чтобы отказаться от прикрепленных файлов
} do

  given!(:user) {create(:user)}
  given!(:question) { create(:question) }
  given!(:answer) {create(:answer, :with_file, user: user, question: question)}

  scenario 'author delete files from own answer', js: true do
    sign_in(user)
    visit question_path(answer.question)
    file = answer.files.all[0]

    expect(page).to have_content(file.filename.to_s)
    within ".answer-file-#{file.id}" do
      click_on "Delete"
    end

    expect(page).to have_no_content(file.filename.to_s)
  end

  scenario 'not author tries delete files from question' do
    user = create(:user)
    sign_in(user)
    visit question_path(answer.question)
    file = answer.files.all[0]
    within ".answer-file-#{file.id}" do
      expect(page).to have_no_link('Delete')
    end
  end

  scenario 'unauthorized user tries delete files from answer' do
    visit question_path(answer.question)
    file = answer.files.all[0]
    within ".answer-file-#{file.id}" do
      expect(page).to have_no_link('Delete')
    end
  end
end