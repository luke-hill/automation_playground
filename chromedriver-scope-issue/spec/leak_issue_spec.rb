require 'spec_helper'

RSpec.describe 'Issue Leaks' do
  let(:page) { Login.new }
  let(:username) { 'ASK' }
  let(:password) { 'ASK' }
  let(:wait) { Selenium::WebDriver::Wait.new }

  before { Capybara.current_window.maximize }

  it 'runs successfully' do
    page.load
    wait.until { page.current_url.end_with?('login') }
    page.login(username, password)
    wait.until { page.text.include?('SIGN OUT') }
  end

  it 'does not run - page load fails' do
    page.load
  end
end
