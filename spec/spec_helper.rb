# OBS Appliance spec helper.
#
# for capybara rspec support
require 'capybara/dsl'
require 'support/capybara'

SCREENSHOT_DIR = "/tmp/rspec_screens"

RSpec.configure do |config|
  #rspec-expectations config goes here.
  config.expect_with :rspec do |expectations|
  # to disable deprecated should syntax
    expectations.syntax = :expect
  end
  config.before(:suite) do
    FileUtils.rm_rf(SCREENSHOT_DIR)
    FileUtils.mkdir_p(SCREENSHOT_DIR)
  end
  config.after(:each) do |example|
    if example.exception
      take_screenshot(example)
    end
  end
  # Limits the available syntax to the non-monkey patched
  config.disable_monkey_patching!
  config.include Capybara::DSL
end


def take_screenshot(example)
  meta            = example.metadata
  filename        = File.basename(meta[:file_path])
  line_number     = meta[:line_number]
  screenshot_name = "screenshot-#{filename}-#{line_number}.png"
  screenshot_path = File.join(SCREENSHOT_DIR, screenshot_name)
  page.save_screenshot(screenshot_path)
  puts meta[:full_description] + "\n Screenshot: #{screenshot_path}"
end

def obs_login (user,password)
    visit "/user/login"
    fill_in 'user_login', with: user 
    fill_in 'user_password', with: password
    click_button('Log In »')
    first(:link,'Logout')
end
