# frozen_string_literal: true

# Cucumber:
#
# Put this file in features/support/helpers/interceptor.rb
#
# Require the file in your env.rb
#
#     require_relative "support/helpers/interceptor"
#
# Add the code as a Worldable module
#
#     World(......,Interceptor)
#
# Include the autorun code in your hooks as the final line of "hook" code in `Before` and the first
# line of code in your `After`
#
#     Before
#       ........
#       start_intercepting
#     end
#
#     After
#       stop_intercepting
#       ......
#     end
#
# How to use:
#
# Call the `intercept` method in any point in your step definitions with the following info
#   -> url
#   -> response
#   -> http method (optional, defaults to "ANY")
#
#     Given('Some step with a specific intercept') do
#       url_to_intercept = 'https://www.google.com/'
#       intercept(url_to_intercept, "fixed response")
#       visit url_to_intercept
#
#       # assert something that depends on the intercepted request
#     end
#
# - You can configure default interceptions that should apply to all tests by overriding the `default_interceptions` method
# - You can configure the allowed requests by overriding the `allowed_requests` method (defaults to any request to the Rails app)

module Interceptor
  # Add an interception hash for a given url, http method, and response
  # @url can be a regexp or a string
  # @method can be a string or a symbol. Can be uppercase or lowercase
  def intercept(url, response = '', method = :ANY)
    @interceptions << { url: url, method: method, response: response }
  end

  def start_intercepting
    raise 'Unsupported Driver' unless page.driver.browser.respond_to?(:intercept)

    # If this isn't the first time this has been invoked, stop as we don't want to attach the interceptor twice
    return if @intercepting

    # Set the default interceptions
    @interceptions = default_interceptions

    page.driver.browser.intercept do |request, &continue|
      url = request.url
      method = request.method

      if (interception = response_for(url, method))
        # set mocked body if there's an interception for the url and method
        continue.call(request) do |response|
          SitePrism.logger.debug("INTERCEPTED #{url}. Will mock response with: #{interception[:response]}")
          response.code ||= 200
          response.headers['Access-Control-Allow-Origin'] = '*'
          response.body = interception[:response]
        end
      elsif allowed_request?(url, method)
        # leave request untouched if allowed
        continue.call(request)
      else
        # intercept any external request with a dummy response and print some logs
        continue.call(request) do |response|
          SitePrism.logger.warn("INTERCEPTED #{url}. Will mock response with dummy string")
          response.body = 'FooBar'
        end
      end
    end
    @intercepting = true
  end

  def stop_intercepting
    return unless @intercepting

    # remove the callback, cleanup
    clear_devtools_intercepts
    @intercepting = false
    # some requests may finish after the test is done if we let them go through untouched
    sleep(0.2)
  end

  # Override this method to define default interceptions that should apply to all tests
  # Each element of the array should be a hash with `url`, `response` and `method` key, like
  # the hash added by the `intercept` method
  #
  # For example:
  # - [{url: "https://external.api.com", response: ""}, {url: another_domain, response: fixed_response, method: :get}]
  def default_interceptions
    []
  end

  # Override this method to add more allowed requests that shouldn't be intercepted
  #
  # Elements of this array can be:
  # - a string
  # - a regexp
  # - a hash with `url` and `method` keys where:
  #   - url can be a string or a regexp
  #   - method can be `:any`, can be omitted (same as setting `:any`), or can be an
  #     http method as symbol or string and lowercase or uppercase
  #
  # For example, these are valid elements for the array:
  # - "https://allowed.domain.com"
  # - {url: "https://allowed.domain.com", method: "GET"} (or {url: /allowed\.domain\.com/, method: :get})
  # - {url: /allowed\.domain\.com/, method: :any} (or {url: /allowed\.domain\.com/} or /allowed\.domain\.com/)
  #
  # NOTE that you probably always want at least the Capybara.server_host url in this array
  def allowed_requests
    [%r{http://#{Capybara.server_host}}]
  end

  private

  # check if the given request url and http method pair is allowed by any rule
  def allowed_request?(url, method = 'GET')
    allowed_requests.any? do |allowed|
      allowed_url = allowed.is_a?(Hash) ? allowed[:url] : allowed
      matches_url = url.match?(allowed_url)

      allowed_method = allowed.is_a?(Hash) ? allowed[:method] : :any
      allowed_method ||= :any
      matches_method = allowed_method == :any || method == allowed_method.to_s.upcase

      matches_url && matches_method
    end
  end

  # find the First matching interception hash for a given url and http method pair
  def response_for(url, method = 'GET')
    @interceptions.detect do |interception|
      matches_url = url.match?(interception[:url])
      intercepted_method = interception[:method] || :any
      matches_method = intercepted_method == :any || method == intercepted_method.to_s.upcase

      matches_url && matches_method
    end
  end

  # clears the devtools callback for the interceptions
  def clear_devtools_intercepts
    callbacks = page.driver.browser.devtools.callbacks
    return unless callbacks.key?('Fetch.requestPaused')

    callbacks.delete('Fetch.requestPaused')
  end
end
