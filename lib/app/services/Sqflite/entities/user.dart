import 'package:bebes/app/modules/user/user_model.dart';
import 'package:bebes/app/services/Sqflite/Table.dart';
import 'package:bebes/app/services/Sqflite/generateField.dart';
import 'package:bebes/app/services/Sqflite/types/filed.type.dart';
import 'package:bebes/app/services/Sqflite/types/primarykey.type.dart';

final userTable = BebesTable<User>(
  "user",
  '_id',
  PrimaryKeyType.uuid,
  GenerateField.generate({
    "name": {
      "type": FieldType.string,
      "defaultValue": "",
      "notNull": true,
      "isUnique": true
    },
    "email": {
      "type": FieldType.string,
      "defaultValue": "",
      "notNull": true,
      "isUnique": true
    },
    "phone": {"type": FieldType.string, "defaultValue": "", "notNull": true},
    "gender": {
      "type": FieldType.string,
      "defaultValue": "",
    },
    "username": {
      "type": FieldType.string,
      "defaultValue": "",
      "notNull": true,
      "isUnique": true
    },
    "birthday": {
      "type": FieldType.string,
      "defaultValue": "",
    },
    "createdAt": {
      "type": FieldType.datetimeAuto,
      "defaultValue": "",
    },
    "updatedAt": {
      "type": FieldType.datetimeAuto,
      "defaultValue": "null",
    },
    "avatarUrl": {
      "type": FieldType.string,
      "defaultValue": "",
    },
    "lastOnline": {"type": FieldType.bigint, "defaultValue": 0}
  }),
);
