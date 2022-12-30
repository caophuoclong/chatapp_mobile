import 'package:bebes/app/services/Sqflite/TableField.dart';
import 'package:bebes/app/services/Sqflite/abstracts/table_field.abstract.dart';

class GenerateField {
  static List<TableField> generate(Map<String, dynamic> fields) {
    List<TableField> result = [];
    fields.forEach((key, value) {
      result.add(Field(key, value["type"], value["defaultValue"],
          isNull: value["isNull"] == true ? true : false));
    });
    return result;
  }
}
