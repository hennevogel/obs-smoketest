require "spec_helper"

RSpec.describe "Project" do
  it "should be able to create" do
    login('Admin','opensuse')
    click_link('Create Home')
    expect(page).to have_content("Create New Project")
    click_button('Create Project')
    expect(page).to have_content("Project 'home:Admin' was created successfully")

    logout
  end

  it "should be able to add repositories" do
    login('Admin','opensuse')
    within("div#subheader") do
      click_link('Home Project')
    end
    expect(current_path).to eq '/project/show/home:Admin'
    click_link('Repositories')
    expect(current_path).to eq '/repositories/home:Admin'
    click_link('Add repositories')
    expect(current_path).to eq '/project/add_repository_from_default_list/home:Admin'
    check('repo_openSUSE_Leap_42_2')
    expect(page).to have_content("Successfully added repository 'openSUSE_Leap_42.2'")

    logout
  end
end
