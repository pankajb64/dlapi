class AddResources < ActiveRecord::Migration

  filename = File.expand_path(File.dirname(__FILE__)) + "/db/migrate/dloneday.txt"
  tablefile = File.open(filename, "r")

  def up
  
	tablefile.each_line do |line|
	  ar = line.split(" ")
	  ar.each do |element|
		unless element == ar[ar.length - 1]
		  
		end
	  end
	  puts
	end
  