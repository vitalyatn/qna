require 'rails_helper'

feature 'User can delete own answer', %q{
  чтобы отказаться от предложенного ответа
} do

  #given(:answers) { create_list(:answer, 20) }
  given(:question) { create(:question) }

  background do
    @question = question
    @answers = create_list(:answer, 5, question: @question)
    @answer = @answers.first
    #byebug
  end

  scenario 'delete own question' do
    user = @answers.first.user
    sign_in(user)
    visit question_path(@answer.question)
    expect(page).to have_content(@answer.body)
    expect(page).to have_content(user.email)
    click_on 'Delete answer'
    expect(page).to have_no_content(@answer.body)
  end

  scenario 'not author tries delete question' do
    user = create(:user)
    sign_in(user)
    visit question_path(@answer.question)
    expect(page).to have_content(@answer.body)
    expect(page).to have_no_content('Delete answer')
  end

  scenario 'unauthorized user tries delete question' do
    visit question_path(@answer.question)
    expect(page).to have_no_content('Delete question')
    save_and_open_page
  end
end