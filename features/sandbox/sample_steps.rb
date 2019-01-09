Given(/^foo is a (!big)(.*)$/) do |bar|
  puts bar
end

Given(/^foo is a biGGg(.*)$/) do |bar|
  puts bar
end

Given(/^foo is a beg (.*)$/) do |bar|
  puts "beg" + bar
end

Given("I pass half of the time") do
  expect(rand).to be < 0.5
end
