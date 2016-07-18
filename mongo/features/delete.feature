Feature: Deleting a mongo

  Rules:
  - when receiving "mongo.delete",
    removes the mongo record with the given id
    and returns "mongo.deleted"


  Background:
    Given an ExoCom server
    And an instance of this service
    And the service contains the mongos:
      | NAME            |
      | Jean-Luc Picard |
      | William Riker   |


  Scenario: deleting an existing mongo
    When sending the message "mongo.delete" with the payload:
      """
      id: '<%= @id_of 'Jean-Luc Picard' %>'
      """
    Then the service replies with "mongo.deleted" and the payload:
      """
      id: /.+/
      name: 'Jean-Luc Picard'
      """
    And the service now contains the mongos:
      | NAME          |
      | William Riker |


  Scenario: trying to delete a non-existing mongo
    When sending the message "mongo.delete" with the payload:
      """
      id: 'zonk'
      """
    Then the service replies with "mongo.not-found" and the payload:
      """
      id: 'zonk'
      """
    And the service now contains the mongos:
      | NAME            |
      | Jean-Luc Picard |
      | William Riker   |
