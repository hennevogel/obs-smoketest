require "spec_helper"

RSpec.describe "Authentification" do
  it "should be able to sign up" do
    visit "/"
    fill_in 'login', with: 'test_user'
    fill_in 'email', with: 'test_user@openqa.com'
    fill_in 'pwd', with: 'opensuse'
    click_button('Sign Up')
    expect(page).to have_content("The account 'test_user' is now active.")
    expect(page).to have_link('link-to-user-home')

    logout
  end

  it "should be able to login" do
    login("Admin", "opensuse")
    expect(page).to have_link('link-to-user-home')

    logout
  end
end
