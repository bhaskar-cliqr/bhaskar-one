class Sanitize_File
	  
	  def initialize(verbose = false)
		      if verbose
			           puts "Enter the string you want to sanitize: \n\n"
				        @sanitize = gets.chomp 
					     @new = sanitize_filename(@sanitize)
					          puts " \nNew file name is  : #{@new} \n\n"
						     end
		        end
	    
	    def sanitize_filename(file_name)
		        file_name.gsub(/[^\w\.\-]/,"_")
			  end
	      
end

m = Sanitize_File.new(true)

