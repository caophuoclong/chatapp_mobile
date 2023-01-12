import 'package:bebes/app/services/Sqflite/Table.dart';
import 'package:bebes/app/services/Sqflite/TableField.dart';
import 'package:bebes/app/services/Sqflite/generateField.dart';
import 'package:bebes/app/services/Sqflite/types/filed.type.dart';
import 'package:bebes/app/services/Sqflite/types/primarykey.type.dart';
import 'package:bebes/app/services/Sqflite/types/relationship.type.dart';
import 'package:get/get.dart';

import '../message_model.dart';

class MessageProvider extends GetConnect {
  final BebesTable<Message> table;
  MessageProvider()
      : table = BebesTable(
            "message",
            "_id",
            PrimaryKeyType.uuid,
            GenerateField.generate({
              "content": {"type": FieldType.longtext},
              "status": {
                "type": FieldType.string,
              },
              "type": {
                "type": FieldType.string,
              },
              "sender": {
                "type": FieldType.uuid,
              },
              "destination": {
                "type": FieldType.uuid,
              },
              "scale": {"type": FieldType.int},
              "isRecall": {"type": FieldType.boolean},
              "isDeleted": {"type": FieldType.boolean},
              "createdAt": {"type": FieldType.datetime}
            }),
            related: {
              "sender": {
                "type": RelationShipType.oneToOne,
                "table": "user",
                "localKey": "_id"
              },
              "destination": {
                "type": RelationShipType.oneToMany,
                "table": "conversation",
                "localKey": "_id"
              }
            });
  @override
  void onInit() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return Message.fromJson(map);
      if (map is List) {
        return map.map((item) => Message.fromJson(item)).toList();
      }
    };
    httpClient.baseUrl = 'YOUR-API-URL';
  }

  Future<List<Message>?> getMessages(String destination,
      {limit = 20, skip = 0}) async {
    final response = await table
        .getMany({"destination": destination}, limit: limit, skip: skip);
    // print("Response getMessage $response");
    return [];
  }

  Future<Response<Message>> postMessage(Message message) async =>
      await post('message', message);
  Future<Response> deleteMessage(int id) async => await delete('message/$id');
}
