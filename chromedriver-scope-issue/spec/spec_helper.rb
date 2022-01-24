require 'capybara'
require 'capybara/dsl'
require 'rspec'
require 'selenium-webdriver'
require 'site_prism'
require 'webdrivers'
require 'automation_helpers'

require_relative '../pages/login'

Capybara.configure do |config|
  config.run_server = false
  config.app_host = 'http://development.globacap.com'
  config.default_driver = :selenium
  config.default_max_wait_time = 0
end

AutomationHelpers::Drivers::Local.new(:chrome).register
