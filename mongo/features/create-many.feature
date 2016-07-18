Feature: Creating multiple mongos

  As an ExoService application
  I want to be able to create multiple mongo records in one transaction
  So that my application doesn't have to send and receive so many messages and remain performant.

  Rules:
  - send the message "mongo.create-many" to create several mongo records at once
  - payload is an array of mongo data
  - when successful, the service replies with "mongo.created-many"
    and the number of newly created records
  - when there is an error, the service replies with "mongo.not-created-many"
    and a message describing the error


  Background:
    Given an ExoCom server
    And an instance of this service


  Scenario: creating valid mongo records
    When sending the message "mongo.create-many" with the payload:
      """
      [
        * name: 'Jean-Luc Picard'
        * name: 'William Riker'
      ]
      """
    Then the service replies with "mongo.created-many" and the payload:
      """
      count: 2
      """
    And the service now contains the mongos:
      | NAME            |
      | Jean-Luc Picard |
      | William Riker   |
