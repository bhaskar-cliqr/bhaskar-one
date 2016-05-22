module Bundles
        def bundle()
          Bundle.new()
        end

	## Actions
	def create(tprops)
	  puts "Create bundle: #{tprops.inspect}" 	
	end
	
	def update(tprops)
	  puts "Update bundle: #{tprops.inspect}"
	end

	def delete(tprops)
          puts "Delete bundle: #{tprops.inspect}"
	end

	def show(tprops)
	  puts "Get bundle: #{tprops.inspect}"
	end

	def discontinue(tprops)
	  puts "Discontinue bundle: #{tprops.inspect}"
	end

	def enable(tprops)
	  puts "Enable bundle: #{tprops.inspect}"
	end
end

class Bundle
  include Bundles
end

__END__
br_obj1 = Rbclasses.new('Bhaskar1','37','Good','Software')
br_obj1.display()
br_obj2 = Rbclasses.new('Bhaskar2','38','Good2','Software Engg')
br_obj2.display()
br_obj1.display()
br_obj1.name = "admin"
br_obj1.display()

