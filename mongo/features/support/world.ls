require! {
  'eco'
}


World = !->

  # Fills in mongo ids in the placeholders of the template
  @fill-in-mongo-ids = (template, done) ->
    needed-ids = []
    eco.render template, id_of: (mongo) -> needed-ids.push mongo
    return done template if needed-ids.length is 0
    @exocom
      ..send-message service: 'mongo', name: 'mongo.read', payload: {name: needed-ids[0]}
      ..wait-until-receive ~>
        id = @exocom.received-messages![0].payload.id
        done eco.render(template, id_of: (mongo) -> id)


  @remove-ids = (payload) ->
    for key, value of payload
      if key is 'id'
        delete payload[key]
      else if typeof value is 'object'
        payload[key] = @remove-ids value
      else if typeof value is 'array'
        payload[key] = [@remove-ids(child) for child in value]
    payload



module.exports = ->
  @World = World
