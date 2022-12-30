import 'package:bebes/app/services/Sqflite/types/filed.type.dart';

class PriamryKeyType {
  static const String intAutoIncrement =
      "${FieldType.int} NOT NULL auto_increment";
  static const String int = "${FieldType.int} NOT NULL";
  static const String uuid = "${FieldType.uuid} NOT NULL";
  static const String string = "${FieldType.string} NOT NULL";
}
