Feature: Use back button for returning to the owner of the masquerade action.
  In order to back to the owner user
  As an masquerade user
  I want to be able to press a simple button on the page

  Scenario: Use back button with cache
    Given I logged in
    And devise masquerade configured to use cache
    And I have a user for masquerade

    When I am on the users page
    And I login as one user
      Then I should be login as this user
      And I should be masqueraded by owner user

    When I press back masquerade button
      Then I should be login as owner user

  Scenario: Use back button with session
    Given I logged in
    And devise masquerade configured to use session
    And I have a user for masquerade

    When I am on the users page
    And I login as one user
      Then I should be login as this user
      And I should be masqueraded by owner user

    When I press back masquerade button
      Then I should be login as owner user
