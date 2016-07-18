Feature: Updating a mongo

  Rules:
  - when receiving "mongo.update",
    updates the mongo record with the given id
    and returns "mongo.updated" with the new record


  Background:
    Given an ExoCom server
    And an instance of this service
    And the service contains the mongos:
      | NAME            |
      | Jean-Luc Picard |
      | William Riker   |


  Scenario: updating an existing mongo
    When sending the message "mongo.update" with the payload:
      """
      id: '<%= @id_of 'Jean-Luc Picard' %>'
      name: 'Cptn. Picard'
      """
    Then the service replies with "mongo.updated" and the payload:
      """
      id: /.+/
      name: 'Cptn. Picard'
      """
    And the service now contains the mongos:
      | NAME          |
      | Cptn. Picard  |
      | William Riker |


  Scenario: trying to update a non-existing mongo
    When sending the message "mongo.update" with the payload:
      """
      id: 'zonk'
      name: 'Cptn. Zonk'
      """
    Then the service replies with "mongo.not-found" and the payload:
      """
      id: 'zonk'
      """
    And the service now contains the mongos:
      | NAME            |
      | Jean-Luc Picard |
      | William Riker   |
