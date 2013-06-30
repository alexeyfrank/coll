load 'application'

action 'sync', ->
  doc = new Document(params.document)
  doc.save (err) ->
    io().sockets.in(params.document_session_id).emit 'message',
      position: 
        ch: doc.positionCh
        line: doc.positionLine
      posDiff: 
        ch: doc.posDiffCh
        line: doc.posDiffLine
      content: doc.content
      key: doc.key
