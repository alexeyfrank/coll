load 'application'

action 'index', ->
  DocumentSession.all (err, rooms) ->
    render 'index',
      title: 'Code collaboration'
      rooms: rooms