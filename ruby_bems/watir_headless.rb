require "rubygems"
gem "test-unit"
require "test/unit"
require "watir-webdriver"

# check arguments for browser or headless specification
ARGV.each { |arg|
	if arg.downcase.include? 'chrome'
		$browser = 'chrome'
	elsif arg.downcase.include? 'firefox'
		$browser = 'firefox'
	elsif arg.downcase.include? 'ff'
		$browser = 'firefox'
	elsif arg.downcase.include? 'ie'
		$browser = 'ie'
	elsif arg.downcase.include? 'headless'
		$headless = true
	end}

class TestExample < Test::Unit::TestCase
	def setup
	  $browser = 'chrome' if $browser.nil?
          $site = '54.191.229.34' if $site.nil?   
	  if $headless
	    require 'headless'
	    $headless = Headless.new
 	    $headless.start
	  end
          if $browser == 'chrome'
		    $b = Watir::Browser.new :chrome
	  elsif $browser == 'firefox'
		    $b = Watir::Browser.new :ff
	  elsif $browser == 'ie'
		    $b = Watir::Browser.new :ie
	  end
	  $b.goto $site
	end
	 
	def teardown
	  $b.close
	  if $headless
	    $headless.destroy
	  end
	end
end

test = TestExample.new('first_case')
test.setup
test.assert_equal 'you@example.com',$b.text_field(:id,'username').placeholder
test.assert_equal 'notyou@example.com',$b.text_field(:id,'username').placeholder
test.teardown

