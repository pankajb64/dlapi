Feature: determine result from given parameters

  As a cricket buff
  So that I can calculate D/L result from given scores
  I want to determine result from given score and other parameters
  
  Background: resources and g50 in database
  
    Given all resources exist in database
    And all g50 values exist in database
    And all the json specific task is done
  
  Scenario: determine result from given parameters should give json
  
    When I am on the home page
    And I fill "data" with "{"format":"ODI","level":"Standard","T1":{"N":50,"suspensions":[{"wickets":5,"score":131,"overs_before":23.0,"overs_after":17.0}],"S":251},"T2":{"N":50,"suspensions":[{"wickets":3,"score":108,"overs_before":26.0,"overs_after":20.0}]}}"
    And I press "Submit"
    Then I should get a json response 
    
  Scenario: determine result should give a target if supplied json has no final Team 2 Score
   
   When I am on the home page
   And I fill "data" with "{"format":"ODI","level":"Standard","T1":{"N":50,"suspensions":[{"wickets":5,"score":131,"overs_before":23.0,"overs_after":17.0}],"S":251},"T2":{"N":50,"suspensions":[{"wickets":3,"score":108,"overs_before":26.0,"overs_after":20.0}]}}"
   And I press "Submit"
   Then the JSON response should have 4 entries
   Then the JSON response at "type" should be "target"
   And the JSON response at "runs" should be 136
   And the JSON response at "wickets" should be 7
   And the JSON response at "overs" should be 20.0
   And the JSON response should not have "status"

  Scenario: determine result should give a result as Tie if both scores are equal in terms of D/L
  
   When I am on the home page
   And I fill "data" with "{"format":"ODI","level":"Standard","T1":{"N":50,"suspensions":[{"wickets":5,"score":131,"overs_before":23.0,"overs_after":17.0}],"S":251},"T2":{"N":50,"suspensions":[{"wickets":3,"score":108,"overs_before":26.0,"overs_after":20.0}], "S" : 243}}"
   And I press "Submit"
   Then the JSON response should have 2 entries
   Then the JSON response at "type" should be "result"
   And the JSON response at "status" should be "Tie"
   And the JSON response should not have the following:
   | "runs" |
   | "wickets" |
   | "overs" |
   | "margin" |   

  Scenario: determine result should give victory to Team 1 if supplied if Team 2 scored less in terms of D/L
  
   When I am on the home page
   And I fill "data" with "{"format":"ODI","level":"Standard","T1":{"N":50,"suspensions":[{"wickets":5,"score":131,"overs_before":23.0,"overs_after":17.0}],"S":251},"T2":{"N":50,"suspensions":[{"wickets":3,"score":108,"overs_before":26.0,"overs_after":20.0}], "S" : 234}}"
   And I press "Submit"
   Then the JSON response should have 3 entries
   Then the JSON response at "type" should be "result"
   And the JSON response at "status" should be "T1"
   And the JSON response at "margin" should be 9
   And the JSON response should not have the following:
   | "runs" |
   | "wickets" |
   | "overs" |            

  Scenario: determine result should give victory to Team 1 if supplied if Team 2 scored more in terms of D/L
  
   When I am on the home page
   And I fill "data" with "{"format":"ODI","level":"Standard","T1":{"N":50,"suspensions":[{"wickets":5,"score":131,"overs_before":23.0,"overs_after":17.0}],"S":251},"T2":{"N":50,"suspensions":[{"wickets":3,"score":108,"overs_before":26.0,"overs_after":20.0}], "S" : 244}}"
   And I press "Submit"
   Then the JSON response should have 3 entries
   Then the JSON response at "type" should be "result"
   And the JSON response at "status" should be "T2"
   And the JSON response at "margin" should be 1
   And the JSON response should not have the following:
   | "runs" |
   | "wickets" |
   | "overs" |            
