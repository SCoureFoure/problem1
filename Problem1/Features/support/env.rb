require 'watir'
require 'pp'

# You could add others I suppose.
$browser = Watir::Browser.new :chrome
$browser.window.resize_to(1920,1080) # For Chrome

$TestResults = []

# This part I am not as sure about.
# I'm have some room to grow in build up and tear down type stuff
at_exit do
passed = 0
failed = 0
$TestResults.each do |result|
 if result.eql? 'pass'
   passed += 1
 else
   failed += 1
 end
end

puts "There were a total of #{$TestResults.count} Tests Ran."
puts "Sorry business client- that is really all I have other than there were
      #{passed.count} passed tests, and #{failed.count} failed tests."
end
