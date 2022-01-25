require 'spec_helper'

RSpec.describe 'Issue Leaks' do
  let(:username) { 'ASK' }
  let(:password) { 'ASK' }
  let(:wait) { Selenium::WebDriver::Wait.new }

  let(:driver) { Selenium::WebDriver.for(:chrome) }

  before { driver.manage.window.maximize }

  it 'runs successfully in selenium' do
    # load page
    driver.get('http://development.globacap.com/login')
    # wait until login loaded
    wait.until { driver.find_element(css: 'input[name="email"]') }
    wait.until { driver.current_url.end_with?('login') }
    # login
    driver.find_element(css: 'input[name="email"]').send_keys(username)
    driver.find_element(css: 'input[name="password"]').send_keys(password)
    driver.find_element(css: '[type="submit"]').click
    # wait until logged in
    wait.until { driver.find_element(css: 'body').text.include?('SIGN OUT') }
  end

  it 'does not run - page load fails' do
    # load page
    driver.get('http://development.globacap.com/login')
    # wait until login loaded
    wait.until { driver.find_element(css: 'input[name="email"]') }
    wait.until { driver.current_url.end_with?('login') }
  end
end
