Feature: Listing all mongos

  Rules:
  - returns all mongos currently stored


  Background:
    Given an ExoCom server
    And an instance of this service


  Scenario: no mongos exist in the database
    When sending the message "mongo.list"
    Then the service replies with "mongos.listing" and the payload:
      """
      count: 0
      mongos: []
      """


  Scenario: mongos exist in the database
    Given the service contains the mongos:
      | NAME            |
      | Jean-Luc Picard |
      | Will Riker      |
    When sending the message "mongo.list"
    Then the service replies with "mongo.listing" and the payload:
      """
      count: 2
      mongos: [
        * name: 'Jean-Luc Picard'
          id: /\d+/
        * name: 'Will Riker'
          id: /\d+/
      ]
      """
