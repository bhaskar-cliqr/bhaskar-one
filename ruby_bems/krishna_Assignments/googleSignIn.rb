#Automated script to perform google sign-in using Ruby and watir

require 'watir-webdriver'
browser = Watir::Browser.new :firefox   #using firefox browser
browser.goto 'http://google.co.in/'

browser.link(:id => "gb_70").click

browser.text_field(:id => "Email").set ("k066016@gmail.com")

browser.button(:id => 'next').click

sleep 2

browser.text_field(:id => "Passwd").set ("610660kcr")

browser.label(:class => "remember").click

browser.button(:id => "signIn").click

puts "Google Log-In Success"

sleep 2

#signing out from google
browser.link(:class => "gb_pa gb_l gb_r gb_h").click

sleep 2

browser.link(:id => "gb_71").click

sleep 2

#validating login using wrong password
browser.link(:id => "gb_70").click

browser.text_field(:id => "Email").set ("k066016@gmail.com")

browser.button(:id => 'next').click

sleep 2

browser.text_field(:id => "Passwd").set ("123456789")

browser.button(:id => "signIn").click

if text = browser.span(:text => "The email and password you entered don't match.") then

puts "login fail, test pass"

else

puts "login pass, test fail"

end

#checking the back arrow image

browser.image(:id => "back-arrow").click

sleep 2

browser.button(:id => 'next').click

sleep 2
puts "back image works"
browser.back
#checking forgot password link

browser.link(:id => "link-forgot-passwd").click

browser.back

sleep 2
puts "forgot password link works"

#checking Sign in with a different account link
browser.link(:text => "Sign in with a different account").click

puts "success"
