Feature: Use back button for returning to the owner despite on expiration time.
  In order to back to the owner user
  As an masquerade user
  I want to be able to press a simple button on the page

  Scenario: Use back button
    Given I logged in
    And I have a user for masquerade

    When I have devise masquerade expiration time in 1 second

    When I am on the users page
    And I login as one user
      Then I should be login as this user
      And I waited for 2 seconds

    When I press back masquerade button
      Then I should be login as owner user
