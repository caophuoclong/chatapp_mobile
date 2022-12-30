import 'package:bebes/app/services/Sqflite/Table.dart';
import 'package:bebes/app/services/Sqflite/generateField.dart';
import 'package:bebes/app/services/Sqflite/types/filed.type.dart';
import 'package:bebes/app/services/Sqflite/types/primarykey.type.dart';
import 'package:bebes/app/services/Sqflite/types/relationship.type.dart';
import 'package:get/get.dart';

import '../contact_model.dart';

class ContactProvider extends GetConnect {
  final BebesTable<Contact> _contactTable;
  ContactProvider()
      : _contactTable = BebesTable(
            "friendShip",
            "_id",
            PriamryKeyType.uuid,
            GenerateField.generate({
              "userRequest": {
                "type": FieldType.uuid,
                "defaultValue": "",
              },
              "userAddress": {
                "type": FieldType.uuid,
                "defaultValue": "",
              },
              "status": {
                "type": FieldType.string,
                "defaultValue": "",
              },
            }),
            related: {
              "userRequest": {
                "type": RelationShipType.oneToOne,
                "table": "user",
                "localKey": "_id"
              },
              "userAddress": {
                "type": RelationShipType.oneToOne,
                "table": "user",
                "localKey": "_id"
              }
            });
  BebesTable<Contact> get table => _contactTable;
  @override
  void onInit() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return Contact.fromJson(map);
      if (map is List) {
        return map.map((item) => Contact.fromJson(item)).toList();
      }
    };
    httpClient.baseUrl = 'YOUR-API-URL';
  }

  Future<Contact?> getFriendship(int id) async {
    final response = await get('friendship/$id');
    return response.body;
  }

  Future<Response<Contact>> postFriendship(Contact friendship) async =>
      await post('friendship', friendship);
  Future<Response> deleteFriendship(int id) async =>
      await delete('friendship/$id');
}
