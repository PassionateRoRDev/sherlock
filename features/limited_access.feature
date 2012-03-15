Feature: Limited Access To Cases
  In order to know my information is secure
  As a visitor
  I want not to have access cases page

  Scenario: Visiting the cases page
    Given I am on the cases page
    Then page title should be "Login to SherlockDocs"
    
