Feature: Dashboard Page
  In order to manage my data
  As a logged in user
  I want to access my dashboard

  Scenario: Logging-in to Dashboard
    Given I am signed in
    Then page title should be "Dashboard"
    
