require 'spec_helper'
require 'active_support'
# Specs in this file have access to a helper object that includes
# the ResourceHelper. For example:
#
# describe ResourceHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe ResourceHelper do
  #pending "add some examples to (or delete) #{__FILE__}"

  before (:all) do
	@j = ActiveSupport::JSON
	filename = File.expand_path(File.dirname(__FILE__)) + "/../../static/json.txt"
	f = File.open(filename, "r")
	@json = f.readline
  end

   before (:each) do
   
     @data = @j.decode(@json, :symbolize_keys => true)
   end      
  
describe 'calculating resource from data and format' do
  
    before (:each) do
    
      Resource.stub(:find_by_format_and_wickets_and_over).and_return(mock('Resource', :resource => 100))
    end
    it 'should call the method that finds the resource by format and wickets lost and overs left in the Resource Model exactly 2n + 1 times where n is the number of suspensions' do
    
      n = @data[:T1][:suspensions].length
      Resource.should_receive(:find_by_format_and_wickets_and_over).exactly(2*n + 1).times
      
      ResourceHelper.calculate_resource(@data[:format], @data[:T1])
    end
    
  end

  describe 'determining result from give resources' do
  
    before(:each) do
    
      ResourceHelper.stub(:find_result).and_return("ha")
      ResourceHelper.stub(:find_target).and_return("ha")
    end
    
    it 'should call the find target method if the final score for team 2 is not given' do
    
      ResourceHelper.should_receive(:find_target)
      ResourceHelper.determine_result(@data[:T1], @data[:T2], 250)
    end
    
    it 'should call the find result method if the final score for team 2 is given' do
    
      ResourceHelper.should_receive(:find_result)
      
      t2 = @data[:T2]
      t2[:S] = 249
      
      ResourceHelper.determine_result(@data[:T1], t2, 250)
    end
  end

  describe 'calculating par score from given parameters' do
  
    it 'should give a lower par score than score for team1 if r1 is greater than r2' do
    
      r1 = 86.5
      r2 = 83.5
      s = 250
      
      ResourceHelper.calculate_par_score(r1, r2, s, 245).should be < s
    end

    it 'should give a higher par score than score for team1 if r2 is greater than r1' do
    
      r2 = 86.5
      r1 = 83.5
      s = 250
      
      ResourceHelper.calculate_par_score(r1, r2, s, 245).should be > s
    end
    
    it 'should give the same par score as the score for team1 if r1 is equal to r2' do
    
      r1 = 86.5
      r2 = r1
      s = 250
      
      ResourceHelper.calculate_par_score(r1, r2, s, 245).should be  s
    end        
  end

  describe 'calculating final result given scores of two teams and par score' do
  
    it 'should give the victory to Team 1 when team2\' score is less than par score' do
    
      t2 = @data[:T2]; t2[:S] = 249
      result = {:type => "result", :status => "T1", :margin => 1}
      ResourceHelper.find_result(@data[:T1], t2, 250).should == result
    end
    
    it 'should give the victory to Team 2 when team2\' score is more than par score' do
    
      t2 = @data[:T2]; t2[:S] = 252
      result = {:type => "result", :status => "T2", :margin => 2}
      ResourceHelper.find_result(@data[:T1], t2, 250).should == result
    end
    
    it 'should give a Tie when team2\' score is equal to par score' do
    
      t2 = @data[:T2]; t2[:S] = 250
      result = {:type => "result", :status => "Tie", }
      ResourceHelper.find_result(@data[:T1], t2, 250).should == result
    end
            
  end

  describe 'calculating final target for team 2 from give scores of two teams and par score' do
  
    before(:each) do
    
      ResourceHelper.stub(:find_current_score_and_overs_left_and_wickets_lost).and_return(200, 15.0, 2)
    end
    
    it 'should call the method that finds the latest score of team 2 and the final number of overs left and the latest number of wickets lost' do
    
      ResourceHelper.should_receive(:find_current_score_and_overs_left_and_wickets_lost)
      
      ResourceHelper.find_target(@data[:T1], @data[:T2], 250)
    end
  end

  describe 'calculating latest score of team 2 and final number of overs left and latest number of wickets lost' do
  
    it 'should return 0, N overs if suspensions array is empty for Team 2' do
    
      t2 = @data[:T2]
      t2[:suspensions] = []
      
      ResourceHelper.find_current_score_and_overs_left_and_wickets_lost(t2).should == [0, @data[:T2][:N], 0]
    end
    
    it 'should return the latest score of team 2 and final number of overs left is there are suspensions, overs left should be < N' do
    
      ResourceHelper.find_current_score_and_overs_left_and_wickets_lost(@data[:T2])[1].should be < @data[:T2][:N] 
    end
  end 
  
end
