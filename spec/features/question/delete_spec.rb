require 'rails_helper'

feature 'User can delete own question', %q{
  чтобы отказаться от помощи участников сообщества
} do

  given(:questions) { create_list(:question, 3) }

  background do
    @question = questions.first
  end

  scenario 'delete own question' do
    user = @question.user
    sign_in(user)
    expect(page).to have_content(@question.title)
    visit question_path(@question)
    expect(page).to have_content(@question.body)
    expect(page).to have_content(user.email)
    click_on 'Delete question'
    expect(page).to have_no_content(@question.title)
  end

  scenario 'not author tries delete question' do
    user = create(:user)
    sign_in(user)
    visit question_path(@question)
    expect(page).to have_no_content(@question.user.email)
    expect(page).to have_no_content('Delete question')
  end

  scenario 'unauthorized user tries delete question' do
    visit question_path(@question)
    expect(page).to have_no_content('Delete question')
  end
end