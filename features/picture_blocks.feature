Feature: Picture Blocks
  In order have good reports
  As a logged in user
  I want to insert picture blocks into my case report

  Scenario: Creating a new picture block
    Given there are the following users:
    | email          | password |
    | user1@mail.com | password |
    And I am on the sign-in page    
    When I sign-in as "user1@mail.com" with password "password"
    And I create a new case with title "Case #1" and summary "Summary of the case"
    And I create a picture block in "Case #1" with title "Picture #1" and file "sample_image1.png"
    Then I should see confirmation "Picture block has been added"

  