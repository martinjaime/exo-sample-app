Feature: Get details for a mongo

  Rules:
  - when receiving "mongo.read",
    returns "mongo.details" with details for the given mongo


  Background:
    Given an ExoCom server
    And an instance of this service
    And the service contains the mongos:
      | NAME            |
      | Jean-Luc Picard |
      | William Riker   |


  Scenario: locating an existing mongo by id
    When sending the message "mongo.read" with the payload:
      """
      id: '<%= @id_of 'Jean-Luc Picard' %>'
      """
    Then the service replies with "mongo.details" and the payload:
      """
      id: /.+/
      name: 'Jean-Luc Picard'
      """


  Scenario: locating a non-existing mongo by id
    When sending the message "mongo.read" with the payload:
      """
      id: 'zonk'
      """
    Then the service replies with "mongo.not-found" and the payload:
      """
      id: 'zonk'
      """
