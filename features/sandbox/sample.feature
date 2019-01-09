@sandbox
Feature: Sample feature
  Scenario: Cucumber fails to load
    Given foo is a biGGg bar

  Scenario: Used to prevent ambiguous steps
    Given foo is a beg bar

  Scenario: Flaky test
    Given I pass half of the time
