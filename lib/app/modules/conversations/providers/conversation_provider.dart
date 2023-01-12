import 'package:bebes/app/modules/user/user_model.dart';
import 'package:bebes/app/services/Sqflite/Table.dart';
import 'package:bebes/app/services/Sqflite/entities/member.dart';
import 'package:bebes/app/services/Sqflite/entities/user.dart';
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
              "avatarUrl": {
                "type": FieldType.string,
                "defaultValue": "",
              },
              "name": {
                "type": FieldType.string,
                "defaultValue": "",
              },
              "type": {
                "type": FieldType.string,
                "defaultValue": "",
              },
              "visible": {"type": FieldType.boolean, "defaultValue": false},
              "createdAt": {
                "type": FieldType.datetime,
                "defaultValue": DateTime.now().toString(),
              },
              "updatedAt": {
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
              "lastMessage": {
                "type": FieldType.uuid,
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
              "lastMessage": {
                "table": "message",
                "localKeyType": PrimaryKeyType.uuid,
                "localKey": "_id",
                "type": RelationShipType.oneToMany
              },
              "members": {
                "table": "user",
                "localKeyType": PrimaryKeyType.uuid,
                "localKey": "_id",
                "type": RelationShipType.manyToMany,
                // "customField": {
                //   "tableName": "members",
                //   "fields": GenerateField.generate({
                //     "createdAt": {
                //       "type": FieldType.datetime,
                //     },
                //     "updatedAt": {
                //       "type": FieldType.datetime,
                //     },
                //     "isDeleted": {
                //       "type": FieldType.boolean,
                //     }
                //   })
                // }
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

  Future<List<User>> _getMembersPerConversation(String conversationId) async {
    final memberIds = await memberTable
        .getMany({"conversation_id": conversationId}, select: "user_id");
    final List<User> members = [];
    for (var memberId in memberIds) {
      final member = await userTable.get({"_id": memberId["user_id"]});
      if (member.isNotEmpty) {
        final mem = User.fromJson(member[0]);
        members.add(mem);
      }
    }
    return members;
  }

  Future<List<Conversation>> getConversations() async {
    final myId = await memberTable.myId;
    final response =
        await memberTable.getMany({"user_id": myId}, select: "conversation_id");
    List<Conversation> conversationsList = [];
    for (var con in response) {
      final conversationId = con["conversation_id"];
      Map<String, dynamic> conversation =
          (await table.get({"_id": conversationId}))[0];
      final members = await _getMembersPerConversation(conversationId);
      print(conversation);
      // print(conversation["type"] == "direct");
      final xxx = {
        ...conversation,
        "name": conversation["name"] == "null" &&
                conversation["type"] == "direct"
            ? members
                .firstWhereOrNull((element) => element.toJson()["_id"] != myId)
                ?.name
            : "98989",
        "avatarUrl": conversation["avatarUrl"] == "null" &&
                conversation["type"] == "direct"
            ? members
                .firstWhereOrNull((element) => element.toJson()["_id"] != myId)
                ?.avatarUrl
            : conversation["avatarUrl"],
        "members": members
      };
      final conx = Conversation.fromJson(xxx);
      conversationsList.add(conx);
    }
    return conversationsList;
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
