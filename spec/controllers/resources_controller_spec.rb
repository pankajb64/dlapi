require 'spec_helper'
require 'active_support'


describe ResourcesController do

   before (:all) do
	@j = ActiveSupport::JSON
	filename = File.expand_path(File.dirname(__FILE__)) + "/../json.txt"
	f = File.open(filename, "r")
	@json = f.readline
   end
   
   before (:each) do
   
	@data = @j.decode(@json, :symbolize_keys => true)
   end
   	   
   describe 'determining result from a given set of parameters' do
   
     it 'should call the methods that calculates result in Resource Model' do
     
       Resource.should_receive(:calculate_result).with(@data)
       
       post :determine_result, { :data => @json }
     end
     
     it 'should render the correct json' do
       Resource.stub(:calculate_result).with(@data).and_return(@data)
       post :determine_result, {:data => @json }
       
       response.body.should == @json
     end
  end     
end
