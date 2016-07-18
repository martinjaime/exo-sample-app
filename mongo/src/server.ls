require! {
  'mongodb' : {MongoClient, ObjectID}
  'nitroglycerin' : N
}
env = require('get-env')('test')


collection = null

module.exports =

  before-all: (done) ->
    mongo-db-name = "exosphere-mongo-service-#{env}"
    MongoClient.connect "mongodb://localhost:27017/#{mongo-db-name}", N (mongo-db) ->
      collection := mongo-db.collection 'mongos'
      console.log "MongoDB '#{mongo-db-name}' connected"
      done!


  # Creates a new mongo object with the given data
  'mongo.create': (mongo-data, {reply}) ->
    collection.insert-one mongo-data, (err, result) ->
      | err  =>
          console.log "Error creating mongo: #{err}"
          reply 'mongo.not-created', error: err
      | _  =>
          console.log "creating mongo"
          reply 'mongo.created', mongo-to-id(result.ops[0])


  'mongo.create-many': (mongos, {reply}) ->
    collection.insert mongos, (err, result) ->
      | err  =>  return reply 'mongo.not-created-many', error: err
      reply 'mongo.created-many', count: result.inserted-count


  'mongo.read': (query, {reply}) ->
    try
      mongo-query = id-to-mongo query
    catch
      console.log "the given query (#{query}) contains an invalid id"
      return reply 'mongo.not-found', query
    collection.find(mongo-query).to-array N (mongos) ->
      switch mongos.length
        | 0  =>
            console.log "mongo '#{mongo-query}' not found"
            reply 'mongo.not-found', query
        | _  =>
            mongo = mongos[0]
            mongo-to-id mongo
            console.log "reading mongo #{mongo.id}"
            reply 'mongo.details', mongo


  # Updates the given mongo object,
  # identified by its 'id' attribute
  'mongo.update': (mongo-data, {reply}) ->
    try
      id = new ObjectID mongo-data.id
    catch
      console.log "the given query (#{mongo-data}) contains an invalid id"
      return reply 'mongo.not-found', id: mongo-data.id
    delete mongo-data.id
    collection.update-one {_id: id}, {$set: mongo-data}, N (result) ->
        | result.modified-count is 0  =>
            console.log "mongo '#{id}' not updated because it doesn't exist"
            return reply 'mongo.not-found'
        | _  =>
            collection.find(_id: id).to-array N (mongos) ->
              mongo = mongos[0]
              mongo-to-id mongo
              console.log "updating mongo #{mongo.id}"
              reply 'mongo.updated', mongo


  'mongo.delete': (query, {reply}) ->
    try
      id = new ObjectID query.id
    catch
      console.log "the given query (#{query}) contains an invalid id"
      return reply 'mongo.not-found', id: query.id
    collection.find(_id: id).to-array N (mongos) ->
      | mongos.length is 0  =>
          console.log "mongo '#{id}' not deleted because it doesn't exist"
          return reply 'mongo.not-found', query
      mongo = mongos[0]
      mongo-to-id mongo
      collection.delete-one _id: id, N (result) ->
        if result.deleted-count is 0
          console.log "mongo '#{id}' not deleted because it doesn't exist"
          return reply 'mongo.not-found', query
        console.log "deleting mongo #{mongo.id}"
        reply 'mongo.deleted', mongo


  'mongo.list': (_, {reply}) ->
    collection.find({}).to-array N (mongos) ->
      mongo-to-ids mongos
      console.log "listing mongos: #{mongos.length} found"
      reply 'mongo.listed', {count: mongos.length, mongos}



# Helpers

function id-to-mongo query
  result = {[k,v] for k,v of query}
  if result.id
    result._id = new ObjectID result.id
    delete result.id
  result


function mongo-to-id entry
  entry.id = entry._id
  delete entry._id
  entry


function mongo-to-ids entries
  for entry in entries
    mongo-to-id entry
