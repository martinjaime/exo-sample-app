class HomeController

  ({@send}) ->


  index: (req, res) ->
    @send 'tweets.list', {}, (data) ->
      res.render 'index', count: data.count, tweets: data.entries



module.exports = HomeController
