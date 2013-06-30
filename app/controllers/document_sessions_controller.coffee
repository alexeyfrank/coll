

load 'application'

action 'show', ->
  v = 1
  Document.all {where: {document_session_id: params.id, to_version_list: "true"}, order: 'timestamp'}, (err, versions) ->
    if versions
      v = versions

    render 'show',
      title: "documents#show",
      versions: v


action 'create', ->
  DocumentSession.create body.DocumentSession, (err, document_session) =>
    if err
      flash 'error', 'document session can not be created'
      redirect path_to.root
    else
      flash 'info', 'Создана новая комната! '
      redirect path_to.document_session(document_session.id)


action 'versions', ->
  Document.findOne {order: 'timestamp DESC'}, (err, old_doc) ->
    console.log(params.id)
    Document.find params.id, (err, new_doc) ->
      console.log new_doc
      console.log old_doc
      render 'versions',
        new_doc: new_doc
        old_doc: old_doc
        title: "versions"