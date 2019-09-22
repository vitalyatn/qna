require 'rails_helper'

feature 'User can sign up', %q{
  чтобы полноценно работать с приложением
  пользователь должен зарегестрироваться
} do

  background do
    visit questions_path
    click_on 'Registration'
    fill_in 'Email', with: "user#{DateTime.now.to_i}@test.com"
    fill_in 'Password', with: '12345678'
  end

  scenario 'User tries to register' do
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'
    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'User tries to register with errors' do
    fill_in 'Password confirmation', with: ''
    click_on 'Sign up'
    expect(page).to have_content 'Sign up'
  end
end