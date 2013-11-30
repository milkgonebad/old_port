Feature:  An Admin can CRUD Tests for a customer

	As an admin
	In order to record the results of a test
	I should be able to CRUD tests on behave of a user
	

Background:
	Given I am an admin with email "some_admin@medsafelabs.com"
	And customer "Bob Small" exists
	

Scenario:  An admin can view a customer's tests
	Given I am on the customer index page
	When I follow the tests link next to "Bob"
	Then I should see a page to create tests for "Bob"

Scenario:  An admin can create a test for a customer
	Given I am on customer "Bob" test page
	When I follow the New Test link
	And I fill in the form
	Then I should be on Bob's test page
	And his test should appear