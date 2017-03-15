require "spec_helper"

RSpec.describe "Interconnect" do
  it "should be able to create link" do
    login("Admin", "opensuse")
    visit "/configuration/interconnect"
    click_button('openSUSE')
    click_button('Save changes')
    expect(page).to have_content("Project 'openSUSE.org' was created successfully")

    logout
  end
end
