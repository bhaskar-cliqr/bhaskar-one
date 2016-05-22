require 'rubygems'
require 'bundles'

class Users
   include Bundles
   
   #attr_accessor :username, :bundle
   attr_accessor :username
   def initialize(test_props)
     puts "Users initialize"
     @username = test_props['username']
     #@bundle = Bundle.new()
   end
  
   def user_create()
     puts "Create user"
   end
end

admin = Users.new({'username' => 'admin' })
test_props = {
	'bundle_name'   => 'admin_bundle',
	'bundle_type'   => 'BUDGET_BASED',
	'bundle_period' => '3',
}
admin.bundle.create(test_props)
admin.bundle.update(test_props)
admin.bundle.delete(test_props)
admin.bundle.show(test_props)


