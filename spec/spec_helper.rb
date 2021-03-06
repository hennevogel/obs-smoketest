# OBS Appliance spec helper.
#
# for capybara rspec support
require 'support/capybara'

SCREENSHOT_DIR = "/tmp/rspec_screens"

RSpec.configure do |config|
  config.before(:suite) do
    FileUtils.rm_rf(SCREENSHOT_DIR)
    FileUtils.mkdir_p(SCREENSHOT_DIR)
  end
  config.after(:each) do |example|
    if example.exception
      take_screenshot(example)
      dump_page(example)
    end
  end
  config.fail_fast = 1
end

def dump_page(example)
  filename = File.basename(example.metadata[:file_path])
  line_number = example.metadata[:line_number]
  dump_name = "dump-#{filename}-#{line_number}.html"
  dump_path = File.join(SCREENSHOT_DIR, dump_name)
  page.save_page(dump_path)
end

def take_screenshot(example)
  filename = File.basename(example.metadata[:file_path])
  line_number = example.metadata[:line_number]
  screenshot_name = "screenshot-#{filename}-#{line_number}.png"
  screenshot_path = File.join(SCREENSHOT_DIR, screenshot_name)
  page.save_screenshot(screenshot_path)
end

def login(user,password)
    visit "/user/login"
    fill_in 'user_login', with: user
    fill_in 'user_password', with: password
    click_button('Log In »')

    expect(page).to have_link('link-to-user-home')
end

def logout
  visit('/user/logout')
  expect(page).to have_no_link('link-to-user-home')
end
