load 'application'


action 'connect', ->
  socket(params.documentSessionId).join(params.documentSessionId)
  Document.findOne {where: {document_session_id: params.documentSessionId}, order: 'timestamp DESC'}, (err, doc) ->
    socket(params.documentSessionId).emit('document:connect:success', content: doc.content) if doc

action 'sync', ->
  doc = new Document(params.document)
  doc.save (err) ->
    socket(doc.document_session_id).emit 'message',
      position: 
        ch: doc.positionCh
        line: doc.positionLine
      posDiff: 
        ch: doc.posDiffCh
        line: doc.posDiffLine
      content: doc.content
      key: doc.key
