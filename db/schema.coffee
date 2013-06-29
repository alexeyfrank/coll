# Example of model definition:
#
#define 'User', ->
#  property 'email', String, index: true
#  property 'password', String
#  property 'activated', Boolean, default: false
#

Post = describe 'Post', ->
    property 'title', String
    property 'content', String
    set 'restPath', pathTo.posts

