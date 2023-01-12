import 'package:bebes/app/services/Sqflite/types/filed.type.dart';

class PrimaryKeyType {
  static const String intAutoIncrement =
      "${FieldType.int} NOT NULL UNIQUE auto_increment";
  static const String int = "${FieldType.int} NOT NULL UNIQUE";
  static const String uuid = "${FieldType.uuid} NOT NULL UNIQUE";
  static const String string = "${FieldType.string} NOT NULL UNIQUE";
  static const String uuidManually = "$uuid, manual";
}
