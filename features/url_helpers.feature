Feature: Use masquerade path to generate routes on page
  In order to have the way to render masquerade path
  As an user
  I want to be able to see the url and use it

  Scenario: Use masquerade path helper
    Given I logged in
    And I have a user for masquerade

    When I am on the users page
      Then I should see maquerade url

    When I am on the users page with extra params
      Then I should see maquerade url with extra params
