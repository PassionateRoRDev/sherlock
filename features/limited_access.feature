Feature: Limited Access
  In order to know my information is secure
  As a visitor
  I want not to have access to any other page than sign-in/sign-up

  Scenario: Visiting the main page
    Given I am on the homepage
    Then I should see "Sign in"
    