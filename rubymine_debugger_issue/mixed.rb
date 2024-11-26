require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'

  # Because of the the way bundle-inline works, require capybara first because of internal helper code
  gem 'capybara'
  gem 'automation_helpers', '~> 5.0'
  gem 'curb'
  # This also is needed just because of helper code
  gem 'faraday'
  gem 'selenium-webdriver', '4.26.0'
  gem 'site_prism', '~> 5.0'
end

require 'curb'
require 'capybara'
require 'site_prism'
require 'selenium-webdriver'
require 'automation_helpers/drivers/local'

puts 'Gems installed and loaded!'

# Register driver and a sample page as quickly as possible

Capybara.configure do |config|
  config.run_server = false
  config.default_driver = :selenium
  config.default_max_wait_time = 0
  config.app_host = 'http://www.google.com/'
end

AutomationHelpers::Drivers::Local.new(:chrome).register

class HomePage < SitePrism::Page
  set_url '/'

  load_validation { sleep 1.5 }

  element :about, 'a', text: 'About'
  element :more, 'a', text: 'Store'
end

home = HomePage.new

# Step 1 - Create a curl handle that will perform a GET
c = Curl::Easy.new('http://www.google.com/') { |curl| curl.verbose = true }

# Step 2 - Perform the curl
c.perform

# Step 3 - Close the handle
c.close

# Step 4 - Run the following 4 commands (All will fail, but shouldn't crash debugger)
# c.perform => Error: the evaluation of `(c.perform).inspect` failed with the exception 'No URL supplied'
# c.foofarbaz => Error: the evaluation of `(c.foobarbaz).inspect` failed with the exception 'undefined method `foobarbaz' for an instance of Curl::Easy'
# c.url + c.url => Error: the evaluation of `(c.url + c.url).inspect` failed with the exception 'undefined method `+' for nil'
# 3/0 => Error: the evaluation of `(3/0).inspect` failed with the exception 'divided by 0'

# Step 5 - Load Homepage
home.load

home.about
