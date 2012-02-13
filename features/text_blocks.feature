Feature: Text Blocks
  As a PI
  I want to insert text into my case report
  So that I can have good reports.

  @javascript @wip
  Scenario: Creating a new text block
    Given I am signed in
      And I have a case entitled "#5"
     When I go to details page of "#5"
      And I select "Text Block" from "block-insert"
      And I press "Insert"
      And I fill in "html_detail_contents" with "So this is the kind of thing that happens when you meet a strange girl at a hotel at 2 in the afternoon."
      And I press "Save"
     Then I should be on details page of "#5"
      And I should see "So this is the kind of thing that happens when"

  Scenario: Editing a text block
    Given I am signed in
      And I have a case entitled "#6"
      And #6 has an html block
     When I go to the details page of "#6"
      And I follow "Edit" within ".block.text"
      And I fill in "html_detail_contents" with "Newt"
      And I press "Save"
     Then I should be on the details page of "#6"
      And I should see "Newt"

  Scenario: Removing a text block
    Given I am signed in
      And I have a case entitled "#6"
      And #6 has an html block with content "hello there ms. mistress"
     When I go to the details page of "#6"
      And I follow "Delete" within ".block.text"
      And I should be on the details page of "#6"
      And I should not see "hello there ms. mistress"

