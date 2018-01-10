@Main_Run
@ProblemOne
Feature: ProblemOne
  Scenario: Verify the right number of values appear on the screen
  Given that I goto the 'first' exercise webpage
  And I check the total number of Labels in the table
  And I check the total number of Values in the table
  Then I should have the same number of Values

  Scenario: Verify the values on the screen are greater than 0
  Given that I goto the 'first' exercise webpage
  And I check all the values in to be over 0
  Then they all should be over 0

  Scenario: Verify the total balance is correct based on the values listed
  Given that I goto the 'first' exercise webpage
  And I capture the totals for labels and values
  And I calculate the total amounts for the table
  Then the total balance is correct based on the values listed

  Scenario: Verify the values are formatted as currencies
  Given that I goto the 'first' exercise webpage
  And I check each text value row in the table
  Then I should find that they are all currencies

  Scenario: Verify the total balance matches the sum of the values
  Given that I goto the 'first' exercise webpage
  Then the total balance matches the sum of the values
