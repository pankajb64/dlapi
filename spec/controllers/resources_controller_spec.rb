require 'spec_helper'
require 'active_support'


describe ResourcesController do

   before do
	j = ActiveSupport::JSON

	@data = { 
	:format => "ODI",

	:level => "Standard",

	:T1 => {

	   :N => 50,
	   
	   :suspensions => [
	   {
		  :wickets => 5,
		  :score => 131,
		  :overs_before => 23.0,
		  :overs_after => 17.0,
	   }
	   ],
	   
	   :S => 251,
	 },

	:T2 => { 

	   :N => 50,
	   
	   :suspensions => [
	   {
		 :wickets => 3,
		 :score => 108,
		 :overs_before => 26.0,
		 :overs_after => 20.0,
	   }
	   ],
	   
	},


	}
	
	@json = j.encode(@data)
	
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
