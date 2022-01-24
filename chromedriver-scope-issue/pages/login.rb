# frozen_string_literal: true

class Login < SitePrism::Page
  set_url '/login'

  load_validation { [has_email_field?(wait: 5), 'Page did not load within 5s'] }

  element :email_field, 'input[name="email"]'
  element :password_field, 'input[name="password"]'
  element :login_button, '[type="submit"]'

  def login(email, password)
    email_field.send_keys(email)
    password_field.send_keys(password)
    login_button.click
  end
end
