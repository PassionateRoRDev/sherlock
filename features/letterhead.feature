Feature: Letterhead
  In order have good reports
  As a logged in user
  I want to define Letterhead to be used in my Reports

  Scenario: Defining a new Letterhead
    Given I am signed in
    When I follow "Create Letterhead"
     And I press "Save"
    Then I should see confirmation "Letterhead was successfully created"
     And I should have 1 letterhead assigned

  Scenario: Defining a new Letterhead with a Logo
    Given I am signed in
    When I follow "Create Letterhead"
     And I attach file "sample_logo1.png" to "Select Image :"
     And I press "Save"
    Then I should have 1 logo assigned
     And there should be 1 logo file in the system
