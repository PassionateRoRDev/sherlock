Feature: Picture Blocks
  In order have good reports
  As a logged in user
  I want to insert picture blocks into my case report

  Scenario: Creating a new picture block
    Given I am signed in
    And I create a new case with title "Case #1" and summary "Summary of the case"
    And I create a picture block in "Case #1" with title "Picture #1" and file "sample_image1.png"
    Then I should see confirmation "Picture block has been added"

  Scenario: Creating a new picture block
    Given I am signed in
    And I create a new case with title "Case #1" and summary "Summary of the case"
    And I create a picture block in "Case #1" with title "Picture #1" and file "sample_image1.png"
    Then picture record for "Case #1" with title "Picture #1" should exist
    And file for picture "Picture #1" in "Case #1" should exist

  Scenario: Removing a picture block
    Given I am signed in
    And I create a new case with title "Case #1" and summary "Summary of the case"
    And I create a picture block in "Case #1" with title "Picture #1" and file "sample_image1.png"
    And I go to details page of "Case #1"
    And I click "Delete" on the 1st block
    Then I should see confirmation "The block was successfully deleted"
    And picture record for "Case #1" should not exist
    And there should be 0 picture files in the system

