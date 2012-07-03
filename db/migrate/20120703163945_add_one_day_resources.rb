class AddOneDayResources < ActiveRecord::Migration

  filename = File.expand_path(File.dirname(__FILE__)) + "/dloneday.txt"
  tablefile = File.open(filename, "r")

  RESOURCES = []

  over = 50.0  
  
  tablefile.each_line do |line|
    ar = line.split(" ")
      wickets = 0
	  ar.each do |element|
	    
	      
	    if element == ar[0]
	      over = element.to_f.round(1)
	    end  
	  
        unless element == ar[ar.length - 1]
          RESOURCES << { :format => 'ODI', :wickets => wickets, :over => over, :resource => element}
          wickets += 1
        end
      end
    
  end
  

  def up
  
	RESOURCES.each do |resource|
	  Resource.create!(resource)
    end
  end

  def down
  
    RESOURCES.each do |resource|
      Resource.find_by_format_and_wickets_and_over_and_resource(resource[:format], resource[:wickets], resource[:over], resource[:resource]).destroy
      end
  end      
  
end  
