// ignore_for_file: overridden_fields, file_names

import 'package:bebes/app/services/Sqflite/abstracts/table.abstract.dart';
import 'package:bebes/app/services/Sqflite/abstracts/table_field.abstract.dart';
import 'package:bebes/app/services/Sqflite/database.dart';
import 'package:bebes/app/services/Sqflite/interfaces/database.interface.dart';
import 'package:bebes/app/services/Sqflite/types/filed.type.dart';
import 'package:bebes/app/services/Sqflite/types/primarykey.type.dart';
import 'package:bebes/app/services/Sqflite/types/relationship.type.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:uuid/uuid.dart';

class BebesTable<T> extends Table implements IDatabase {
  static const uuid = Uuid();

  Future<Database> db;
  @override
  final dynamic defaultPrimaryKeyValue;
  @override
  final String tableName;
  @override
  final String primaryKey;
  @override
  final String primaryKeyType;
  @override
  final List<TableField> fields;
  // related with another table as foreign key (one to many)
  @override
  final Map<String, Map<String, dynamic>> related;

  BebesTable(this.tableName, this.primaryKey, this.primaryKeyType, this.fields,
      {this.related = const {}, this.defaultPrimaryKeyValue})
      : db = BebesDatabase("bebes").db {
    db.then((result) async {
      if (related.isNotEmpty) {
        await result.execute(_generateQueryWithRelated());
        await _createTableRelation();
      } else {
        await result.execute(_generateQuery());
      }
    });
  }
  _generateQuery({relation = ""}) {
    if (relation.length == 0) {
      return '''
    CREATE TABLE IF NOT EXISTS $tableName (
      $primaryKey $primaryKeyType,
      ${fields.map((field) => "${field.name} ${field.type} ${field.isNull ? 'NULL' : 'NOT NULL'}").join(",")},
      PRIMARY KEY ($primaryKey)
    )
    ''';
    } else {
      return '''
    CREATE TABLE IF NOT EXISTS $tableName (
      $primaryKey $primaryKeyType,
      ${fields.map((field) => "${field.name} ${field.type} ${field.isNull ? 'NULL' : 'NOT NULL'}").join(",")},
      PRIMARY KEY($primaryKey),
      $relation
    )
    ''';
    }
  }

  _generateQueryWithRelated() {
    List<String> arr = [];
    related.forEach((key, value) {
      if (value["type"] == RelationShipType.manyToMany) return;
      arr.add('''
      FOREIGN KEY ($key) REFERENCES ${value["table"]}(${value["localKey"]})
      ''');
    });
    return _generateQuery(relation: arr.join(","));
  }

  _createTableRelation() async {
    related.forEach((key, value) async {
      switch (value["type"]) {
        case RelationShipType.oneToOne:
          break;
        case RelationShipType.oneToMany:
          break;
        case RelationShipType.manyToMany:
          // table name tb1_tb2
          final String tableName = "${this.tableName}_$key";
          // with custom field
          String query;
          if (value["customField"].isEmpty) {
            query = '''
            CREATE TABLE IF NOT EXISTS $tableName (
              ${this.tableName}$primaryKey $primaryKeyType,
              ${value["table"]}${value["localKey"]} ${value["localKeyType"]},
              PRIMARY KEY(${this.tableName}$primaryKey, ${value["table"]}_${value["localKey"]}),
              FOREIGN KEY(${this.tableName}$primaryKey) REFERENCES ${this.tableName}($primaryKey),
              FOREIGN KEY(${value["table"]}${value["localKey"]}) REFERENCES ${value["table"]}(${value["localKey"]})
            );''';
          } else {
            String? tableName = value["customField"]["tableName"];
            List<TableField> fields = value["customField"]["fields"];
            query = '''
            CREATE TABLE IF NOT EXISTS ${tableName ?? this.tableName}(
              ${this.tableName}$primaryKey $primaryKeyType,
              ${value["table"]}${value["localKey"]} ${value["localKeyType"]},
              ${fields.map((field) => "${field.name} ${field.type} ${field.isNull ? 'NULL' : 'NOT NULL'}").join(",")},
              PRIMARY KEY(${this.tableName}$primaryKey, ${value["table"]}${value["localKey"]}),
              FOREIGN KEY(${this.tableName}$primaryKey) REFERENCES ${this.tableName}($primaryKey),
              FOREIGN KEY(${value["table"]}${value["localKey"]}) REFERENCES ${value["table"]}(${value["localKey"]})
            );''';
          }
          (await db).execute(query);
          break;
        default:
          print("Type of relationship not found");
          return;
      }
    });
  }

  _getData(Map<String, dynamic> where,
      {select = "*", relations, limit = 1}) async {
    // bool withJoin = false;
    // if (select.runtimeType == List) {
    //   select = select.join(",");
    // }
    // if (relations.runtimeType != String) {
    //   throw Exception("Relations must be an array");
    // }

    // if (!RegExp(r"^\w+(\s*,\s*\w+)*$").hasMatch(relations)) {
    //   throw Exception("Relations does not match with regex");
    // }
    // final relationsList = relations.split(",").map((value) {
    //   if (related[value.trim()] == null) {
    //     throw Exception("Relation $value not found");
    //   }
    //   switch (related[value.trim()]!["type"]) {
    //     case RelationShipType.manyToMany:
    //       return "";
    //   }
    // });
    String query = '''
    SELECT $select 
    FROM $tableName 
    WHERE ${where.keys.map((key) => "$key = ${where[key]}").join(" AND ")} 
    LIMIT $limit;
    ''';
    return (await (await db).execute(query));
  }

  /// This a function to get data from database
  ///
  /// @param where is a map of key and value
  ///
  /// @param select is a string or list of string
  ///
  /// @param relations is a string
  ///
  /// Example:
  ///
  /// get({"id": 1}, select: ["id", "name"], relations: "user, post")
  @override
  get(Map<String, dynamic> where, {select = "*", relations}) async {
    if (select.runtimeType == List) {
      select = select.join(",");
    }
    if (relations.runtimeType != String) {
      throw Exception("Relations must be an array");
    }
    if (!RegExp(r"^\w+(\s*,\s*\w+)*$").hasMatch(relations)) {
      throw Exception("Relations does not match with regex");
    }
    return _getData(where, select: select, relations: relations, limit: 1);
  }

  /// This a function to get data from database
  /// @param where is a map of key and value
  /// @param select is a string or list of string
  /// @param relations is a string
  /// Example:
  /// get({"id": 1}, select: ["id", "name"], relations: "user, post")
  @override
  Future<List<T>> getMany(Map<String, dynamic> where,
      {select = "*", relations}) async {
    if (select.runtimeType == List) {
      select = select.join(",");
    }
    if (relations.runtimeType != String) {
      throw Exception("Relations must be an array");
    }
    if (!RegExp(r"^\w+(\s*,\s*\w+)*$").hasMatch(relations)) {
      throw Exception("Relations does not match with regex");
    }
    return _getData(where, select: select, relations: relations, limit: 1);
  }

  _defaultValue() {
    if (primaryKeyType == PrimaryKeyType.uuid &&
        defaultPrimaryKeyValue == null) {
      return BebesTable.uuid.v4();
    } else {
      throw Exception("Primary key value not found");
    }
  }

  @override
  insert(Map<String, dynamic> model) async {
    String query;
    if (primaryKeyType == PrimaryKeyType.intAutoIncrement) {
      query = '''
    INSERT INTO $tableName (${fields.map((field) => field.type == FieldType.datetimeAuto ? "" : field.name).join(",")}) VALUES (${fields.map((field) => field.type == FieldType.datetimeAuto ? "" : "'${model[field.name]}'").join(",")});
    ''';
    } else {
      final String defaultPrimaryKey = _defaultValue();
      query = '''
    INSERT INTO $tableName ($primaryKey,${fields.map((field) => field.type == FieldType.datetimeAuto ? "" : field.name).join(",")}) VALUES ('$defaultPrimaryKey',${fields.map((field) => field.type == FieldType.datetimeAuto ? "" : "'${model[field.name]}'").join(",")});
    ''';
    }
    return (await db).execute(query);
  }

  @override
  update(Map<String, dynamic> model) {
    String query = '''
  UPDATE $tableName
  SET ${model.map((key, value) => MapEntry(key, "$key = '$value'")).values.join(",")}
  WHERE $primaryKey = '${model[primaryKey]}';
  ''';
    return db.then((value) => value.execute(query));
  }

  @override
  delete() {}
}
