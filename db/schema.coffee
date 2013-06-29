Document = describe 'Document', ->
    property 'id', String
    property 'content', String
    property 'timestamp', String
    set 'restPath', pathTo.documents

DocumentSession = describe 'DocumentSession', ->
    property 'id', String
    set 'restPath', pathTo.documentSessions

