require 'rails_helper'

feature 'User can delete files from own question', %q{
  чтобы отказаться от прикрепленных файлов
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, :with_file, user: user) }

  scenario 'author delete files from own question', js: true do
    sign_in(user)
    visit question_path(question)
    file = question.files.all[0]
    expect(page).to have_content(file.filename.to_s)
    within ".file-#{file.id}" do
      click_on "Delete"
    end
    expect(page).to have_no_content(file.filename.to_s)
  end

  scenario 'not author tries delete files from question' do
    user = create(:user)
    sign_in(user)
    visit question_path(question)
    file = question.files.all[0]
    within ".file-#{file.id}" do
      expect(page).to have_no_link('Delete')
    end
  end

  scenario 'unauthorized user tries delete files from question' do
    visit question_path(question)
    file = question.files.all[0]
    within ".file-#{file.id}" do
      expect(page).to have_no_link('Delete')
    end
  end
end