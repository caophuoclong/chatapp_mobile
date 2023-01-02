// type to sql type

class FieldType {
  static const String longtext = "longtext";
  static const String boolean = "bit";
  static const String int = "int";
  static const String bigint = "bigint";
  static const String string = "varchar(255)";
  static const String double = "double";
  static const String date = "date";
  static const String datetime = "datetime";
  static const String datetimeAuto = "datetime DEFAULT CURRENT_TIMESTAMP";
  static const String time = "time";
  static const String timestamp = "timestamp";
  static const String blob = "blob";
  static const String json = "json";
  static const String uuid = "varchar(36)";
}
