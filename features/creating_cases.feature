Feature: Creating Cases
  In order to earn money
  As a logged in user
  I want to create a new case

  Scenario: Going to the New Case page
    Given there are the following users:
    | email          | password |
    | user1@mail.com | password |
    And I am on the sign-in page    
    When I sign-in as "user1@mail.com" with password "password"
    And I go to the new case page
    Then page title should be "Create New Case"


  Scenario: Creating a blank new case
    Given there are the following users:
    | email          | password |
    | user1@mail.com | password |
    And I am on the sign-in page    
    When I sign-in as "user1@mail.com" with password "password"
    And I go to the new case page
    And I fill in "Title" with "Case #1"
    And I fill in "Summary" with "Summary of the case"
    And I press "Save"
    Then page title should be "My Cases"
    And I should see confirmation "Case has been successfully created"
    And the list of cases should contain 1 case

  Scenario: Creating two blank new cases
    Given there are the following users:
    | email          | password |
    | user1@mail.com | password |
    And I am on the sign-in page    
    When I sign-in as "user1@mail.com" with password "password"
    And I go to the new case page
    And I fill in "Title" with "Case #1"
    And I fill in "Summary" with "Summary of the first case"
    And I press "Save"
    And I go to the new case page
    And I fill in "Title" with "Case #2"
    And I fill in "Summary" with "Summary of the second case"
    And I press "Save"    
    Then page title should be "My Cases"
    And I should see confirmation "Case has been successfully created"
    And the list of cases should contain 2 cases

  
    