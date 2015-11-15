#Script to automate google sign-in using Ruby+Watir+DataMagic
#Improvements made in this version:
#   All test data is stored in a saperate yml file and is accessed using DataMagic
#   Used a function to save screenshots
#   Updated the testcases
#New improvements in V5 include
#    Creating zip files from the images and delete the images
#    Included a loop to execute the test cases

require 'watir-webdriver'
require 'data_magic'
require 'zip'
require 'fileutils'
include DataMagic

DataMagic.yml_directory = "/home/bhaskar/"
DataMagic.load "testdata.yml"
$browser = Watir::Browser.new :firefox
$browser.window.maximize

$zip_folder = "/home/bhaskar/"     #Folder where the zip files will be saved
$image_folder = "/home/bhaskar/tmp/"       #Temporary folder to save image files
FileUtils.mkdir("#{$image_folder}")         #Create the temporary directory
$var = "Testcase"
$testcase = ""
#Using a method to take screenshots
class Screenshot
    def initialize
        @var2 = 1
    end
    #Method to take screenshots
    def take_screenshot
        $browser.screenshot.save "#{$image_folder}#{$testcase}_#{@var2}.png"
        @var2+=1
    end
    #Method to create Zip files
    def zipfiles
        @zipfile_name = "#{$zip_folder}#{$testcase}.zip"
        Zip::File.open("#{@zipfile_name}", Zip::File::CREATE) do |zipfile|
            Dir.glob("#{$image_folder}#{$testcase}*").each do |filename|
                file = File.basename("#{filename}")
                zipfile.add(file, "#{$image_folder}" + file)
            end
        end
    end  
end

5.downto(1) do |i|
#for i in 5..1
    $testcase = "#{$var}_" + "#{i}".rjust(3,'0')
    testData = data_for :"#{$testcase}"
    puts "#{$testcase}:" + testData.inspect
#    testData.each do |key, value|
#        puts "\t#{key}: #{value}" end
    test = Screenshot.new
    $browser.goto "#{testData['url']}"
    test.take_screenshot
    $browser.link(:id => "gb_70").when_present.click
    test.take_screenshot
    #If email is already present then select sign-in with a different account to re-enter email
    if $browser.span(:id => "reauthEmail").exist?
        $browser.link(:id => "account-chooser-link").when_present.click
        test.take_screenshot
        $browser.link(:id => "account-chooser-add-account").when_present.click
        test.take_screenshot
    end
    #Enter email and click next
    $browser.text_field(:id => "Email").when_present.set "#{testData['email']}"
    test.take_screenshot
    $browser.button(:id => "next").click
    #Wait before checking the condition for error message
    Watir::Wait.until { $browser.text_field(:class => "form-error").exist? || 
                        $browser.text_field(:id => "Passwd").exist? }
    test.take_screenshot
    #To check if the error message is present or not
    if $browser.text_field(:class => "form-error").exists?
        puts "\tActual result: Email is not accepted"
        test.zipfiles
        next
    elsif !testData.key?('password')        #If password not present then skip to next loop, do not continue to enter password page
        puts "\tActual result: Email is accepted"
        test.zipfiles
        next
    end
    $browser.text_field(:id => "Passwd").when_present.set "#{testData['password']}"
    test.take_screenshot

    #Condition to check or uncheck the stay signed-in checkbox if it exists in test data
    if testData.key?('signincheck')
        "#{testData['signincheck']}" == "true" ? $browser.checkbox(:id => "PersistentCookie").set(true) 
                                     : $browser.checkbox(:id => "PersistentCookie").set(false)
    end
    test.take_screenshot
    $browser.button(:id => "signIn").click
    Watir::Wait.until { $browser.text_field(:class => "form-error").exists? || 
                        $browser.link(:title => "Google Account: #{testData['email']}").exists? }
    test.take_screenshot
    #Check whether user is logged in or not
    if $browser.text_field(:class => "form-error").exists?
        puts "\tActual result: Login Fail"
        test.zipfiles
        next
    elsif $browser.link(:title => "Google Account: #{testData['email']}").exists?
        puts "\tActual result: Login success"
        #If the user is signed in then sign out
        $browser.link(:class => "gb_pa gb_l gb_r gb_h").when_present.click
        $browser.link(:id => "gb_71").when_present.click
        Watir::Wait.until { $browser.link(:id => "gb_70").exists? }  #To make sure the user is signed out
        test.zipfiles
    end  
end
FileUtils.rm_rf("#{$image_folder}")     #Deletes the temporary directory containing images
$browser.close
puts "All zip files containing screenshots saved to #{$zip_folder}"
