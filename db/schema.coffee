Document = describe 'Document', ->
    property 'id', String
    property 'document_session_id', String
    property 'content', String
    property 'timestamp', String
    set 'restPath', pathTo.documents

DocumentSession = describe 'DocumentSession', ->
    property 'id', String
    set 'restPath', pathTo.documentSessions

User = describe 'User', ->
    property 'id', String
    set 'restPath', pathTo.users

UserDocument = describe 'UserDocument', ->
    property 'id', String
    property 'user_id', String
    property 'document_id', String
    property 'position', String
    set 'restPath', pathTo.UserDocuments

