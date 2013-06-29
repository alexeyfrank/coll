Document = describe 'Document', ->
    property 'id', String
    property 'content', String
    property 'timestamp', String
    set 'restPath', pathTo.documents