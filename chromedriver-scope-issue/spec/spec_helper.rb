require 'capybara'
require 'capybara/dsl'
require 'rspec'
require 'selenium-webdriver'
require 'webdrivers'
require 'automation_helpers'

Capybara.configure do |config|
  config.run_server = false
  config.app_host = 'http://development.globacap.com'
  config.default_driver = :selenium
  config.default_max_wait_time = 0
end

desired_capabilities = ::Selenium::WebDriver::Remote::Capabilities.new
options = ::Selenium::WebDriver::Chrome::Options.new

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    service: nil,
    capabilities: [desired_capabilities, options]
  )
end
