require 'spec_helper'

describe Resource do
  #pending "add some examples to (or delete) #{__FILE__}"
  
  before do
  
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
  end
  describe 'calculating result from data' do
  
    before (:each) do
    
       Resource.stub(:calculate_resource).and_return("ha")
       Resource.stub(:determine_result).and_return("ha")
       @g50 = G50.create!(:level => "Standard", :value => 245)
       G50.stub(:find_by_level).and_return(@g50)
       #@g51 = G50.create(:level => "Standard", :value => 245)
       #warn "g50 is #{@g50}"
       #warn "This is a warning"
    end
       
    it 'should call the method that calculates resources from suspensions twice' do
    
      Resource.should_receive(:calculate_resource).twice
      
      Resource.calculate_result(@data)
    end
    
    it 'should find the appropriate G50' do
    
      G50.should_receive(:find_by_level)
      
      Resource.calculate_result(@data)
    end
    
    it 'should call the "determine result" method in Resource Model' do
    
      Resource.should_receive(:determine_result)
      
      Resource.calculate_result(@data)
    end  
  end
end
