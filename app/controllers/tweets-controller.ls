class TweetsController

  ({@send}) ->


  create: (req, res) ->
    @send 'tweets.create', content: req.body.content, owner_id: '1', ->
      res.redirect '/'


  destroy: (req, res) ->
    @send 'tweets.delete', req.params, ->
      res.redirect '/'



module.exports = TweetsController

