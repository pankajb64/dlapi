filename = File.expand_path(File.dirname(__FILE__)) + "/db/migrate/dloneday.txt"
tablefile = File.open(filename, "r")

tablefile.each_line do |line|
  ar = line.split(" ")
  ar.each do |element|
    unless element == ar[ar.length - 1]
	  print element.to_f
	end
  end
  puts
end
  