require "spec_helper"

RSpec.describe "Package" do

  it "should be able to create new" do
    login('Admin','opensuse')
    within("div#subheader") do
      click_link('Home Project')
    end
    expect(current_path).to eq '/project/show/home:Admin'
    click_link('Create package')
    fill_in 'name', with: 'ctris'
    fill_in 'title', with: 'ctris'
    fill_in 'description', with: 'ctris'
    click_button('Save changes')
    expect(page).to have_content("Package 'ctris' was created successfully")

    logout
  end

  it "should be able to upload files" do
    login('Admin','opensuse')
    within("div#subheader") do
      click_link('Home Project')
    end
    expect(current_path).to eq '/project/show/home:Admin'
    click_link('ctris')
    expect(current_path).to eq '/package/show/home:Admin/ctris'
    click_link('Add file')
    attach_file("file", File.expand_path('../../fixtures/ctris.spec', __FILE__))
    click_button('Save changes')
    expect(page).to have_content("The file 'ctris.spec' has been successfully saved.")

    # second line of defense ;-)
    click_link('Add file')
    attach_file("file", File.expand_path('../../fixtures/ctris-0.42.tar.bz2', __FILE__))
    click_button('Save changes')
    expect(page).to have_content("The file 'ctris-0.42.tar.bz2' has been successfully saved.")

    logout
  end

  it "should be able to branch" do
    login('Admin','opensuse')
    within("div#subheader") do
      click_link('Home Project')
    end
    expect(current_path).to eq '/project/show/home:Admin'
    click_link('Branch existing package')
    fill_in 'linked_project', with: 'openSUSE.org:OBS:Server:Unstable'
    fill_in 'linked_package', with: 'build'
    click_button('Create Branch')
    expect(page).to have_content('Successfully branched package')

    # cleaup
    visit('/package/show/home:Admin/build')
    click_link('Delete package')
    click_button('Ok')
    expect(page).to have_content('Package was successfully removed.')

    logout
  end

  it "should be able to successfully build" do
    login('Admin','opensuse')

    counter = 100
    while counter > 0 do
      visit("/package/show/home:Admin/ctris")
      # wait for the build results ajax call
      sleep(5)
      puts "Refreshed build results, #{counter} retries left."
      succeed_build = page.all('td', class: 'status_succeeded')
      if succeed_build.length == 1
        counter = 0
      else
        counter -= 1
      end
    end

    logout
  end
end
