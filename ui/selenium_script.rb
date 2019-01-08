require 'selenium-webdriver'
require 'rspec/expectations'
require 'dotenv'

include RSpec::Matchers

def setup
  Dotenv.load('.env')
  @driver = Selenium::WebDriver.for(ENV['browser'].to_sym)
end

def teardown
  @driver.quit
end

def run
  setup
  yield
  teardown
end

run do
  @driver.get("http://the-internet.herokuapp.com/drag_and_drop")
  puts 'Testing first box'
  expect(@driver.find_element(id: 'column-a').text).to eq('A')
  puts 'Testing second box'
  expect(@driver.find_element(id: 'column-b').text).to eq('B')
  sleep 1
  puts 'Quitting'
end
