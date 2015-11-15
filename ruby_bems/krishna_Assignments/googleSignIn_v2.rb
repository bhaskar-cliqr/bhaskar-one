#Automated script to perform google sign-in using Ruby and watir
#Removed all the sleep statements and replaced them with "when_present"

require 'watir-webdriver'
browser = Watir::Browser.new :firefox   #using firefox browser
browser.goto 'http://google.co.in/'

browser.link(:id => "gb_70").click

browser.text_field(:id => "Email").set ("k066016@gmail.com")

browser.button(:id => 'next').click
browser.text_field(:id => "Passwd").when_present.set ("610660kcr")

browser.label(:class => "remember").click

browser.button(:id => "signIn").click

puts "Google Log-In Success"

#signing out from google
browser.link(:class => "gb_pa gb_l gb_r gb_h").when_present.click
browser.link(:id => "gb_71").click

#validating login using wrong password
browser.link(:id => "gb_70").click

browser.text_field(:id => "Email").set ("k066016@gmail.com")

browser.button(:id => 'next').click
browser.text_field(:id => "Passwd").when_present.set ("123456789")
browser.button(:id => "signIn").click
if text = browser.span(:text => "The email and password you entered don't match.") then

puts "login fail, test pass"

else

puts "login pass, test fail"

end

#checking the back arrow image

browser.image(:id => "back-arrow").click
browser.button(:id => 'next').when_present.click
puts "back image works"
browser.back
#checking forgot password link

browser.link(:id => "link-forgot-passwd").click

browser.back

puts "forgot password link works"

#checking Sign in with a different account link
browser.link(:text => "Sign in with a different account").click

puts "success"
