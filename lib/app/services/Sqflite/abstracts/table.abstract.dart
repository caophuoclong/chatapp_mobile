import 'package:bebes/app/services/Sqflite/abstracts/table_field.abstract.dart';

abstract class Table<T> {
  late String tableName;
  late String primaryKey;
  late String primaryKeyType;
  late List<TableField> fields;
  /*
   *Example:
   *  {
   *  "tableName":{
   *  localKeyType: PrimaryKeyType,
   *  foreignKey: "conversation_id",
   *  localKey: "_id"
   *  customField: {
   * name: {
   * type: FieldType,
   * defaultValue: DefaultValue,
   * isNull: true
   * }
   *  }
   * }
   * }
   */
  late Map<String, Map<String, dynamic>>

      /// `related` is a map that contains the name of the table and
      /// the foreign key, local key of the table and
      /// type of relationship (one to one, one to many, many to many)
      related;
}
