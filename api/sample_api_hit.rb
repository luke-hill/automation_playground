puts 'Starting API test sample'
require 'curb'
require 'json'

# GET
full_url = 'http://www.google.com/'
c = Curl::Easy.new(full_url) do |curl|
  curl.verbose = true
end

c.perform
File.write('response', c.response_code)
c.close

# POST
c2 = Curl::Easy.new("http://my.rails.box/thing/create")

pf1 = Curl::PostField.content('thing[name]', 'box')
pf2 = Curl::PostField.content('thing[type]', 'storage')

c2.http_post(pf1, pf2)

c2&.close
