exports.routes = (map)->
  map.root('welcome#index');

  map.socket('document:sync', 'documents#sync');
  map.socket('document:connect', 'documents#connect');

  map.resources 'document_sessions'

  # Generic routes. Add all your routes below this line
  # feel free to remove generic routes
  map.all ':controller/:action'
  map.all ':controller/:action/:id'
