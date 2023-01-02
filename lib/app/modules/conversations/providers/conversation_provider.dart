import 'package:bebes/app/services/Sqflite/Table.dart';
import 'package:bebes/app/services/Sqflite/generateField.dart';
import 'package:bebes/app/services/Sqflite/types/filed.type.dart';
import 'package:bebes/app/services/Sqflite/types/primarykey.type.dart';
import 'package:bebes/app/services/Sqflite/types/relationship.type.dart';
import 'package:get/get.dart';

import '../conversation_model.dart';

class ConversationProvider extends GetConnect {
  final BebesTable<Conversation> _conversationTable;
  ConversationProvider()
      : _conversationTable = BebesTable(
            "conversation",
            '_id',
            PrimaryKeyType.uuid,
            GenerateField.generate({
              "name": {
                "type": FieldType.string,
                "defaultValue": "",
              },
              "type": {
                "type": FieldType.string,
                "defaultValue": "",
              },
              "created_at": {
                "type": FieldType.datetime,
                "defaultValue": DateTime.now().toString(),
              },
              "updated_at": {
                "type": FieldType.datetime,
                "defaultValue": DateTime.now().toString(),
              },
              "owner": {
                "type": FieldType.uuid,
                "defaultValue": "",
              },
              "isBlocked": {
                "type": FieldType.boolean,
                "defaultValue": false,
              },
              "isDeleted": {
                "type": FieldType.boolean,
                "defaultValue": false,
              },
              "blockBy": {
                "type": FieldType.uuid,
                "defaultValue": "",
              },
              "lastMessage": {
                "type": FieldType.string,
                "defaultValue": "",
              },
              "friendShip": {
                "type": FieldType.uuid,
                "defaultValue": "",
              },
            }),
            related: {
              "owner": {
                "table": "user",
                "localKeyType": PrimaryKeyType.uuid,
                "localKey": "_id",
                "type": RelationShipType.oneToOne
              },
              "friendShip": {
                "table": "friendShip",
                "localKeyType": PrimaryKeyType.uuid,
                "localKey": "_id",
                "type": RelationShipType.oneToOne
              },
              "members": {
                "table": "user",
                "localKeyType": PrimaryKeyType.uuid,
                "localKey": "_id",
                "type": RelationShipType.manyToMany,
                "customField": {
                  "tableName": "members",
                  "fields": GenerateField.generate({
                    "createdAt": {
                      "type": FieldType.datetime,
                    },
                    "updatedAt": {
                      "type": FieldType.datetime,
                    },
                    "isDeleted": {
                      "type": FieldType.boolean,
                    }
                  })
                }
              }
            });
  BebesTable<Conversation> get table => _conversationTable;

  @override
  void onInit() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return Conversation.fromJson(map);
      if (map is List) {
        return map.map((item) => Conversation.fromJson(item)).toList();
      }
    };
    httpClient.baseUrl = 'YOUR-API-URL';
  }

  Future<Conversation?> getConversation(int id) async {
    final response = await get('conversation/$id');
    return response.body;
  }

  Future<Response<Conversation>> postConversation(
          Conversation conversation) async =>
      await post('conversation', conversation);
  Future<Response> deleteConversation(int id) async =>
      await delete('conversation/$id');
}
