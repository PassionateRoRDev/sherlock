Feature: Creating Picture Blocks
  In order have good reports
  As a logged in user
  I want to insert picture blocks into my case report

  Scenario: Going to the New Case page
    Given there are the following users:
    | email          | password |
    | user1@mail.com | password |
    And I am on the sign-in page    
    When I sign-in as "user1@mail.com" with password "password"
    And I go to the new case page
    And I fill in "Title" with "Case #1"
    And I fill in "Summary" with "Summary of the case"
    And I press "Save"
    And I go to details page of "Case #1"
    And I follow "Add picture block"
    And I fill in "Title" with "Picture #1"
    And I attach file "sample_image1.png" to "Select Image:"
    And I press "Save"
    Then I should see confirmation "Picture block has been added"
