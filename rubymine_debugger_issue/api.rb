require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'

  gem 'curb'
end

require 'curb'

puts 'Gems installed and loaded!'

# Step 1 - Create a curl handle that will perform a GET
c = Curl::Easy.new('http://www.google.com/') { |curl| curl.verbose = true }

# Step 2 - Perform the curl
c.perform

# Step 3 - Output the response code
p c.response_code

# Step 4 - Close the handle
c.close

# Step 5 - Run the following 3 commands (All will fail, but shouldn't crash debugger)
# c.perform => Error: the evaluation of `(c.perform).inspect` failed with the exception 'No URL supplied'
# c.foofarbaz => Error: the evaluation of `(c.foobarbaz).inspect` failed with the exception 'undefined method `foobarbaz' for an instance of Curl::Easy'
# c.url + c.url => Error: the evaluation of `(c.url + c.url).inspect` failed with the exception 'undefined method `+' for nil'
