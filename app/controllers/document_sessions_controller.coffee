load 'application'

action 'show', ->
  render
    title: "documents#show"

action 'create', ->
  DocumentSession.create body.DocumentSession, (err, document_session) =>
    if err
      flash 'error', 'document session can not be created'
      redirect path_to.root
    else
      flash 'info', 'Создана новая комната! '
      redirect path_to.document_session(document_session.id)


action 'versions', ->
  render
    title: "versions"