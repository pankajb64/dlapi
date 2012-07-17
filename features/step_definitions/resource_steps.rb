require 'active_support'
require 'capybara/rails'
require 'capybara/cucumber'


Given /all resources exist in database/ do
 
    
 	if not defined?(RESOURCES)
 	  RESOURCES = []
 	
 	  
		filename = File.expand_path(File.dirname(__FILE__)) + "/../../static/dloneday.txt"
		tablefile = File.open(filename, "r")
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
    end 

    RESOURCES.each do |resource|
      Resource.create! (resource)
    end  
    
    
    
    #RESOURCES.each do |resource|
	 # Resource.create!(resource)
    #end
end    
 	
Given /all g50 values exist in database/ do


  if not defined? (G50_VALUES)
    G50_VALUES = []
  
    filename = File.expand_path(File.dirname(__FILE__)) + "/../../static/g50.txt"
    f = File.open(filename, "r")    
    f.each_line do |line|
  
      ar = line.split(" ")
      G50_VALUES << { :level => ar[0], :value => ar[1] }
    end
  end  
  
  G50_VALUES.each do |g50|
    G50.create!(g50)
  end  
  
end

Given /all the json specific task is done/ do

  @json = ActiveSupport::JSON
end
When /I am on the home page/ do
  visit('/home')
end

When /I fill "(.*)" with "(.*)"/ do |field, value|

  fill_in(field, :with => value)
end

When /I press "(.*)"/ do |button|

  click_button(button)
end

Then /I should get a json response/ do
  assert  @json.decode(page.source) != nil
end  

Then /the JSON response should not have the following:/ do |table|
  
  table.rows.each do |row|
    step %Q{the JSON response should not have #{row[0]}} 
  end
end
