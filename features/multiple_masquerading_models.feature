Feature: Use various models for masquerading
  In order to use various models for masquerading
  As an masquerade user
  I want to be able to press press masquerade as link for different models

  Scenario: Use masquerade button on student and user models
    Given I logged in
    And I have a user for masquerade
    And I have a student for masquerade

    When I am on the users page
    And I login as one user
      Then I should be login as this user

    When I am on the students page
    And I login as one student
      Then I should be login as this student
