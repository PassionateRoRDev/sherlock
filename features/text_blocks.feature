Feature: Text Blocks
  As a PI
  I want to insert text into my case report
  So that I can have good reports.

  Scenario: Creating a new text block
    Given I am signed in
      And I have a case entitled "#5"
     When I go to details page of "#5"
      And I follow "Add text block"
      And I fill in "Contents" with "So this is the kind of thing that happens when you meet a strange girl at a hotel at 2 in the afternoon."
      And I press "Save"
     Then I should be on details page of "#5"
      And I should see "So this is the kind of thing that happens when"

