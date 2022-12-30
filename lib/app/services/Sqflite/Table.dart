// ignore_for_file: overridden_fields, file_names

import 'package:bebes/app/services/Sqflite/abstracts/table.abstract.dart';
import 'package:bebes/app/services/Sqflite/abstracts/table_field.abstract.dart';
import 'package:bebes/app/services/Sqflite/database.dart';
import 'package:bebes/app/services/Sqflite/generateField.dart';
import 'package:bebes/app/services/Sqflite/interfaces/database.interface.dart';
import 'package:bebes/app/services/Sqflite/types/relationship.type.dart';
import 'package:sqflite/sqlite_api.dart';

class BebesTable<T> extends Table implements IDatabase {
  Future<Database> db;
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
      {this.related = const {}})
      : db = BebesDatabase("bebes").db {
    print("init db");
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

  @override
  get(Map<String, dynamic> where, {select = "*"}) async {
    // TODO: implement get
    String query = '''
    SELECT $select FROM $tableName WHERE ${where.keys.map((key) => "$key = ${where[key]}").join(" AND ")} LIMIT 1;
    ''';
    return (await (await db).execute(query)) as T;
  }

  @override
  Future<List<T>> getMany(Map<String, dynamic> where, {select = "*"}) async {
    String query = '''
    SELECT $select FROM $tableName WHERE ${where.keys.map((key) => "$key = ${where[key]}").join(" AND ")};
    ''';
    return (await db).execute(query) as List<T>;
  }

  @override
  insert() {}
  @override
  update() {}
  @override
  delete() {}
}
