import 'package:bebes/app/services/Sqflite/Table.dart';
import 'package:bebes/app/services/Sqflite/TableField.dart';
import 'package:bebes/app/services/Sqflite/generateField.dart';
import 'package:bebes/app/services/Sqflite/types/filed.type.dart';
import 'package:bebes/app/services/Sqflite/types/primarykey.type.dart';

final memberTable = BebesTable(
    "members",
    "",
    PrimaryKeyType.uuid,
    GenerateField.generate({
      "conversation_id": {"type": FieldType.uuid},
      "user_id": {"type": FieldType.uuid}
    }));
