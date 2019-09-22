require 'rails_helper'

feature 'User can see question and answer', %q{
  чтобы узнать информацию по интересующей задаче
} do

  given(:question) { create(:question) }

  scenario 'show list of questions' do
    visit question_path(question)
    expect(page).to have_content "MyText"
  end

end