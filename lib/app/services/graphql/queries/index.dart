const String getConversations = r'''
query{
    conversations{
       _id,
       type,
       visible,
       name,
       avatarUrl,
       owner{
           _id
       },
       lastMessage{
           _id
       },
       members{
           _id,
           name,
           username,
           email,
           phone,
           gender,
           birthday,
           createdAt,
           updatedAt,
           lastOnline,
           avatarUrl
       }
    }
}
''';
const String getMessagesPerConversation = '''
query getMessages(\$destination: String!, \$take: Float!, \$skip: Float!){
    messages(destination: \$destination, take: \$take, skip: \$skip){
            _id,
            content,
            type,
            isRecall,
            sender{
              _id,
              avatarUrl
            },
            destination{
              _id
            },
    }
}
''';
const String getMeQurey = r'''
  query{
    getMe{
        _id
        name,
        username,
        email,
        phone,
        birthday,
        lastOnline,
        gender,
        avatarUrl
    }
}
''';
const String refreshTokenQuery = '''
query getToken(\$refreshToken: String!){
    refreshtoken(refreshToken: \$refreshToken){
            userId,
            token,
            expired_time
    }
}
''';
