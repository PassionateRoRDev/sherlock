Feature: Dashboard Page
  In order to manage my data
  As a logged in user
  I want to access my dashboard

  Scenario: Logging-in to Dashboard
    Given there are the following users:
    | email          | password |
    | user1@mail.com | password |
    And I am on the sign-in page    
    And I sign-in as "user1@mail.com" with password "password"
    Then page title should be "My Dashboard"
    