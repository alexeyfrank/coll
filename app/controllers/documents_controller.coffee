load 'application'

action 'sync', ->
  doc = new Document(params.document)
  io().sockets.emit 'message', position: { ch: doc.positionCh, line: doc.positionLine}, posDiff: {ch: doc.posDiffCh, line: doc.posDiffLine}, content: doc.content, key: doc.key
