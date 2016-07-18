Feature: Creating mongos

  Rules:
  - when successful, the service replies with "mongo.created"
    and the newly created record
  - when there is an error, the service replies with "mongo.not-created"
    and a message describing the error


  Background:
    Given an ExoCom server
    And an instance of this service


  Scenario: creating a valid mongo account
    When sending the message "mongo.create" with the payload:
      """
      name: 'Jean-Luc Picard'
      """
    Then the service replies with "mongo.created" and the payload:
      """
      id: /\d+/
      name: 'Jean-Luc Picard'
      """
    And the service now contains the mongos:
      | NAME            |
      | Jean-Luc Picard |
