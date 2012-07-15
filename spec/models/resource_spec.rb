require 'spec_helper'
require 'active_support'

describe Resource do
  #pending "add some examples to (or delete) #{__FILE__}"
  
  before (:all) do
	@j = ActiveSupport::JSON
	filename = File.expand_path(File.dirname(__FILE__)) + "/../json.txt"
	f = File.open(filename, "r")
	@json = f.readline
  end
  
  before (:each) do
  
	@data = @j.decode(@json, :symbolize_keys => true)
  end
  	    
  describe 'calculating result from data' do
  
    before (:each) do
    
       ResourceHelper.stub(:calculate_resource).and_return("ha")
       ResourceHelper.stub(:determine_result).and_return("ha")
       ResourceHelper.stub(:calculate_par_score).and_return(100)
       @g50 = G50.create!(:level => "Standard", :value => 245)
       G50.stub(:find_by_level).and_return(@g50)
       #@g51 = G50.create(:level => "Standard", :value => 245)
       #warn "g50 is #{@g50}"
       #warn "This is a warning"
    end
       
    it 'should call the method that calculates resources from suspensions twice' do
    
      ResourceHelper.should_receive(:calculate_resource).twice
      
      Resource.calculate_result(@data)
    end
    
    it 'should find the appropriate G50 with the appropriate level parameter' do
    
      G50.should_receive(:find_by_level).with(@data[:level])
      
      Resource.calculate_result(@data)
    end
    
    it 'should call the method that calculates the par score' do
    
      ResourceHelper.should_receive(:calculate_par_score)
      
      Resource.calculate_result(@data)
    end

    it 'should call the "determine result" method in Resource Model' do
    
      ResourceHelper.should_receive(:determine_result)
      
      Resource.calculate_result(@data)
    end  
  end

end
