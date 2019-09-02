require 'rails_helper'

feature 'User can sign out', %q{
  чтобы завершить работу с приложением
  пользователь должен выйти
} do

  given(:user) { create(:user) }

  background { visit questions_path }

  scenario 'Registred user tries to sign out' do
    sign_in(user)
    click_on 'Log out'
    #save_and_open_page
    expect(page).to have_content 'Signed out successfully.'
  end
end