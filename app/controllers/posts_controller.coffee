load 'application'

before 'load post', ->
  Post.find params.id, (err, post) =>
    if err || !post
      if !err && !post && params.format == 'json'
        return send code: 404, error: 'Not found'
      redirect pathTo.posts
    else
      @post = post
      next()
, only: ['show', 'edit', 'update', 'destroy']

action 'new', ->
  @post = new Post
  @title = 'New post'
  render()

action 'create', ->
  Post.create body.Post, (err, post) =>
    respondTo (format) =>
      format.json ->
        if err
          send code: 500, error: post.errors || err
        else
          send code: 200, data: post.toObject()
      format.html =>
        if err
          flash 'error', 'Post can not be created'
          @post = post
          @title = 'New post'
          render 'new'
        else
          flash 'info', 'Post created'
          redirect pathTo.posts

action 'index', ->
  Post.all (err, posts) =>
    @posts = posts
    @title = 'Post index'
    respondTo (format) ->
      format.json ->
        send code: 200, data: posts
      format.html ->
        render posts: posts

action 'show', ->
  @title = 'Post show'
  respondTo (format) =>
    format.json =>
      send code: 200, data: @post
    format.html ->
      render()

action 'edit', ->
  @title = 'Post edit'
  respondTo (format) =>
    format.json =>
      send code: 200, data: @post
    format.html ->
      render()

action 'update', ->
  @post.updateAttributes body.Post, (err) =>
    respondTo (format) =>
      format.json =>
        if err
          send code: 500, error: @post.errors || err
        else
          send code: 200, data: @post
      format.html =>
        if !err
          flash 'info', 'Post updated'
          redirect path_to.post(@post)
        else
          flash 'error', 'Post can not be updated'
          @title = 'Edit post details'
          render 'edit'

action 'destroy', ->
  @post.destroy (error) ->
    respondTo (format) ->
      format.json ->
        if error
          send code: 500, error: error
        else
          send code: 200
      format.html ->
        if error
          flash 'error', 'Can not destroy post'
        else
          flash 'info', 'Post successfully removed'
        send "'" + path_to.posts + "'"
