Feature: Creating Cases
  In order to earn money
  As a logged in user
  I want to create a new case

  Scenario: Going to the New Case page
    Given I am signed in
    When I go to the new case page
    Then page title should be "Create New Case"

  Scenario: Creating a blank new case
    Given I am signed in
    And I go to the new case page
    And I fill in "Title" with "Case #1"
    And I fill in "Summary" with "Summary of the case"
    And I press "Save"
    Then page title should be "My Cases"
    And I should see confirmation "Case has been successfully created"
    And the list of cases should contain 1 case

  Scenario: Cases appear in the list 
    Given I am signed in
      And I have a case entitled "Case #1"
      And I have a case entitled "Case #2"
      And I go to the cases page
    Then page title should be "My Cases"
    And the list of cases should contain 2 cases
    And I should see "Case #1"
    And I should see "Case #2"

