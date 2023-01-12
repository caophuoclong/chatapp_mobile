import 'package:bebes/app/services/Sqflite/abstracts/table_field.abstract.dart';

class Field extends TableField {
  final String name;
  final String type;
  final dynamic defaultValue;
  final bool notNull;
  final bool isUnique;
  Field(this.name, this.type, this.defaultValue,
      {this.notNull = true, this.isUnique = false});
}
