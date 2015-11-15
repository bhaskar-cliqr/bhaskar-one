#Script to automate google sign-in using Ruby+Watir+DataMagic
#Improvements made in this version:
#   All test data is stored in a saperate yml file and is accessed using DataMagic
#   Used a function to save screenshots
#   Updated the testcases

require 'watir-webdriver'
require 'data_magic'
include DataMagic

DataMagic.yml_directory = "/home/krishna/Krishna/"
DataMagic.load "testdata.yml"
$browser = Watir::Browser.new :firefox
$browser.window.maximize

#Using a method to take screenshots
class Screenshot
    def initialize(testcase, count)
        @var1 = testcase
        @var2 = count
    end
    def take_screenshot
        $browser.screenshot.save "/home/krishna/Krishna/temp/#{@var1}_#{@var2}.png"
        @var2+=1
    end
end

#Testcase_001
testData = data_for :Testcase_001
puts "Testcase_001:"
testData.each do |key, value|
    puts "\t#{key}: #{value}" end
testcase1 = Screenshot.new("Testcase_001",1)
$browser.goto "#{testData['url']}"
testcase1.take_screenshot
$browser.link(:id => "gb_70").when_present.click
testcase1.take_screenshot
$browser.text_field(:id => "Email").when_present.set "#{testData['email']}"
testcase1.take_screenshot
$browser.button(:id => "next").click
testcase1.take_screenshot
$browser.text_field(:id => "Passwd").when_present.set "#{testData['password']}"
testcase1.take_screenshot

#Condition to check or uncheck the stay signed-in checkbox
"#{testData['signincheck']}" == "true" ? $browser.checkbox(:id => "PersistentCookie").set(true) 
                                     : $browser.checkbox(:id => "PersistentCookie").set(false)
testcase1.take_screenshot

$browser.button(:id => "signIn").click

#To check if the user is signed in or not
if $browser.link(:title => "Google Account: #{testData['email']}").exists?
    testcase1.take_screenshot
    puts "\tActual result: Login success\nTestcase_001 Pass"
    #If the user is signed in then sign out
    $browser.link(:class => "gb_pa gb_l gb_r gb_h").when_present.click
    $browser.link(:id => "gb_71").when_present.click
    Watir::Wait.until { $browser.link(:id => "gb_70").exists? }  #To make sure the user is signed out
else
    testcase1.take_screenshot
    puts "\tActual result: Login fail\nTestcase_001 Fail"
end

#Testcase_002
testData = data_for :Testcase_002
puts "Testcase_002:"
testData.each do |key, value|
    puts "\t#{key}: #{value}" end
testcase2 = Screenshot.new("Testcase_002",1)
$browser.goto "#{testData['url']}"      #To make sure the testcase starts from the first page
testcase2.take_screenshot
$browser.link(:id => "gb_70").when_present.click
testcase2.take_screenshot
$browser.text_field(:id => "Email").when_present.set "#{testData['email']}"
testcase2.take_screenshot
$browser.button(:id => "next").click
$browser.text_field(:id => "Passwd").when_present.set "#{testData['password']}"
testcase2.take_screenshot
#Check the condition for stay signed-in checkbox
"#{testData['signincheck']}" == "true" ? $browser.checkbox(:id => "PersistentCookie").set(true) 
                                     : $browser.checkbox(:id => "PersistentCookie").set(false)
                                     
testcase2.take_screenshot
$browser.button(:id => "signIn").click
if $browser.link(:title => "Google Account: #{testData['email']}").exists?
    testcase2.take_screenshot
    puts "\tActual result: Login Success\nTestcase_002 Pass"
    #If the user is logged in then log out
    $browser.link(:class => "gb_pa gb_l gb_r gb_h").when_present.click
    $browser.link(:id => "gb_71").when_present.click
    Watir::Wait.until { $browser.link(:id => "gb_70").exists? }  #Make sure user log's out properly
else
    testcase1.take_screenshot
    puts "\tActual result: Login fail\nTestcase_002 Fail"
end

#Testcase_003
testData = data_for :Testcase_003
puts "Testcase_003:"
testData.each do |key, value|
    puts "\t#{key}: #{value}" end
testcase3 = Screenshot.new("Testcase_003",1)
$browser.goto "#{testData['url']}"
testcase3.take_screenshot
$browser.link(:id => "gb_70").when_present.click
testcase3.take_screenshot
#If email is already present then select sign-in with a different account to re-enter email
if $browser.span(:id => "reauthEmail").exist?
    $browser.link(:id => "account-chooser-link").when_present.click
    testcase3.take_screenshot
    $browser.link(:id => "account-chooser-add-account").when_present.click
    testcase3.take_screenshot
end
$browser.text_field(:id => "Email").when_present.set "#{testData['email']}"
testcase3.take_screenshot
$browser.button(:id => "next").click    
$browser.text_field(:id => "Passwd").when_present.set "#{testData['password']}"
testcase3.take_screenshot

$browser.button(:id => "signIn").click

#Condition to check if the error message appears or not
if $browser.span(:id => "errormsg_0_Passwd").exists?
    testcase3.take_screenshot
    puts "\tActual result: Login fail\nTestcase_003 Pass"
else
    testcase3.take_screenshot
    puts "\tActual result: Login pass\nTestcase_003 Fail"
    #If the test fails and the user is logged in, then log out
    $browser.link(:class => "gb_pa gb_l gb_r gb_h").when_present.click
    $browser.link(:id => "gb_71").when_present.click
    Watir::Wait.until { $browser.link(:id => "gb_70").exists? }
end

#Testcase_004
testData = data_for :Testcase_004
puts "Testcase_004:"
testData.each do |key, value|
    puts "\t#{key}: #{value}" end
testcase4 = Screenshot.new("Testcase_004",1)
$browser.goto "#{testData['url']}"
testcase4.take_screenshot
$browser.link(:id => "gb_70").when_present.click
testcase4.take_screenshot
$browser.link(:id => "gb_70").wait_while_present
#If email is already present then select sign-in with a different account to re-enter email
if $browser.span(:id => "reauthEmail").exist?
    $browser.link(:id => "account-chooser-link").when_present.click
    testcase4.take_screenshot
    $browser.link(:id => "account-chooser-add-account").when_present.click
    testcase4.take_screenshot
end
$browser.text_field(:id => "Email").when_present.set "#{testData['email']}"
testcase4.take_screenshot
$browser.button(:id => "next").click
#sleep 2     #To give enough time for the error message to appear before the condition is checked
#Wait before checking the condition for error message
Watir::Wait.until { $browser.span(:text => "Sorry, Google doesn't recognize that email.").exist? || 
                    $browser.text_field(:id => "Passwd").exist? }
#To check if the error message is present or not
if $browser.span(:text => "Sorry, Google doesn't recognize that email.").exists?
    testcase4.take_screenshot
    puts "\tActual result: Email is not accepted\nTestcase_004 Pass"
else
    testcase4.take_screenshot
    puts "\tActual result: Email is accepted\nTestcase_004 Fail"
end

#Testcase_005
testData = data_for :Testcase_005
puts "Testcase_005:"
testData.each do |key, value|
    puts "\t#{key}: #{value}" end
testcase5 = Screenshot.new("Testcase_005",1)
$browser.goto "#{testData['url']}"
testcase5.take_screenshot
$browser.link(:id => "gb_70").when_present.click
testcase5.take_screenshot
$browser.link(:id => "gb_70").wait_while_present
#If email is already present then select sign-in with a different account to re-enter email
if $browser.span(:id => "reauthEmail").exist?
    $browser.link(:id => "account-chooser-link").when_present.click
    testcase5.take_screenshot
    $browser.link(:id => "account-chooser-add-account").when_present.click
    testcase5.take_screenshot
end
$browser.text_field(:id => "Email").when_present.set "#{testData['email']}"
testcase5.take_screenshot
$browser.button(:id => "next").click
#sleep 2     #To give enough time for the error message to appear before the condition is checked
#Wait before checking the condition for error message
Watir::Wait.until { $browser.span(:text => "Sorry, Google doesn't recognize that email.").exist? || 
                    $browser.text_field(:id => "Passwd").exist? }
#Condition to check for the error message
if $browser.span(:text => "Sorry, Google doesn't recognize that email.").exists?
    testcase5.take_screenshot
    puts "\tActual result: Email is not accepted\nTestcase_005 Fail"
else
    testcase5.take_screenshot
    puts "\tActual result: Email is accepted\nTestcase_005 Pass"
end

puts "All screen shots saved to location /home/krishna/Krishna/temp/"
