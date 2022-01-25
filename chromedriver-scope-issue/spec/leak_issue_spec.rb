require 'spec_helper'

include Capybara::DSL

RSpec.describe 'Issue Leaks' do
  let(:username) { 'ASK' }
  let(:password) { 'ASK' }
  let(:wait) { Selenium::WebDriver::Wait.new }

  before { Capybara.current_window.maximize }

  it 'runs successfully' do
    # load page
    visit('/login')
    # wait until login loaded
    wait.until { page.has_css?('input[name="email"]') }
    wait.until { page.current_url.end_with?('login') }
    # login
    page.find('input[name="email"]').send_keys(username)
    page.find('input[name="password"]').send_keys(password)
    page.find('[type="submit"]').click
    # wait until logged in
    wait.until { page.text.include?('SIGN OUT') }
  end

  it 'does not run - page load fails' do
    # load page
    visit('/login')
    # wait until login loaded
    wait.until { page.has_css?('input[name="email"]') }
    wait.until { page.current_url.end_with?('login') }
  end
end
