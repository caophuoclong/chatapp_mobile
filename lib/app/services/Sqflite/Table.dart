// ignore_for_file: overridden_fields, file_names

import 'dart:convert';

import 'package:bebes/app/constants/shared_key.dart';
import 'package:bebes/app/services/Sqflite/abstracts/table.abstract.dart';
import 'package:bebes/app/services/Sqflite/abstracts/table_field.abstract.dart';
import 'package:bebes/app/services/Sqflite/database.dart';
import 'package:bebes/app/services/Sqflite/entities/member.dart';
import 'package:bebes/app/services/Sqflite/entities/user.dart';
import 'package:bebes/app/services/Sqflite/interfaces/database.interface.dart';
import 'package:bebes/app/services/Sqflite/types/filed.type.dart';
import 'package:bebes/app/services/Sqflite/types/primarykey.type.dart';
import 'package:bebes/app/services/Sqflite/types/relationship.type.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  List<String> get fieldsKeys {
    return fields.map((e) => e.name).toList();
  }

  Future<String?> get myId async {
    // get from sharedPreference with SharedKey.authKey
    final SharedPreferences _ = await SharedPreferences.getInstance();
    return json.decode(_.getString(SharedKey.authKey) ?? "{}")["userId"];
  }

  BebesTable(this.tableName, this.primaryKey, this.primaryKeyType, this.fields,
      {this.related = const {}, this.defaultPrimaryKeyValue})
      : db = BebesDatabase("bebes").db {
    db.then((result) async {
      if (related.isNotEmpty) {
        await result.execute(_generateQueryWithRelated());
        await _createTableRelation();
      } else {
        final query = _generateQuery();
        if (query != null) {
          await result.execute(_generateQuery());
        }
      }
    });
  }
  _generateQuery({relation = ""}) {
    if (primaryKey.isEmpty) {
      return;
    }
    if (relation.length == 0) {
      return '''
    CREATE TABLE IF NOT EXISTS $tableName (
      $primaryKey $primaryKeyType,
      ${fields.map((field) => "${field.name} ${field.type} ${field.notNull ? '' : 'NOT NULL'} ${field.isUnique ? 'UNIQUE' : ''}").join(",")},
      PRIMARY KEY ($primaryKey)
    )
    ''';
    } else {
      return '''
    CREATE TABLE IF NOT EXISTS $tableName (
      $primaryKey $primaryKeyType,
      ${fields.map((field) => "${field.name} ${field.type} ${field.notNull ? '' : 'NOT NULL'} ${field.isUnique ? 'UNIQUE' : ''}").join(",")},
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
          final String tableName = key;
          // with custom field
          print("many to many");
          print(value["customField"] == null);
          String query;
          if (value["customField"] == null || value["customField"].isEmpty) {
            query = '''
            CREATE TABLE IF NOT EXISTS $tableName (
              ${this.tableName}$primaryKey varchar(36) NOT NULL,
              ${value["table"]}${value["localKey"]} varchar(36) NOT NULL,
              PRIMARY KEY(${this.tableName}$primaryKey, ${value["table"]}${value["localKey"]}),
              FOREIGN KEY(${this.tableName}$primaryKey) REFERENCES ${this.tableName}($primaryKey),
              FOREIGN KEY(${value["table"]}${value["localKey"]}) REFERENCES ${value["table"]}(${value["localKey"]})
            );''';
          } else {
            String? tableName = value["customField"]["tableName"];
            List<TableField> fields = value["customField"]["fields"];
            query = '''
            CREATE TABLE IF NOT EXISTS ${tableName ?? this.tableName}(
              ${this.tableName}$primaryKey varchar(36) NOT NULL,
              ${value["table"]}${value["localKey"]} varchar(36) NOT NULL,
              ${fields.map((field) => "${field.name} ${field.type} ${field.notNull ? '' : 'NOT NULL'}").join(",")},
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
      {select = "*", relations, limit = 1, skip = 0}) async {
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
    String query;
    if (limit.runtimeType != num ||
        limit == "*" ||
        limit.towLowerCase() == "all") {
      query = '''
    SELECT $select 
    FROM $tableName 
    WHERE ${where.keys.map((key) => "$key = '${where[key]}'").join(" AND ")} 
    ''';
    } else {
      query = '''
    SELECT $select 
    FROM $tableName 
    WHERE ${where.keys.map((key) => "$key = '${where[key]}'").join(" AND ")} 
    LIMIT $limit
    OFFSET $skip
    ''';
    }
    return (await (await db).rawQuery(query));
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
    if (relations != null) {
      if (relations.runtimeType != String) {
        throw Exception("Relations must be an array");
      }
      if (!RegExp(r"^\w+(\s*,\s*\w+)*$").hasMatch(relations)) {
        throw Exception("Relations does not match with regex");
      }
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
  Future<dynamic> getMany(Map<String, dynamic> where,
      {select = "*", limit = "*", skip = 0}) async {
    if (select.runtimeType == List) {
      select = select.join(",");
    }
    // print("where $where");
    // if (relations.runtimeType != String) {
    //   throw Exception("Relations must be an array");
    // }
    // if (!RegExp(r"^\w+(\s*,\s*\w+)*$").hasMatch(relations)) {
    //   throw Exception("Relations does not match with regex");
    // }
    return _getData(where, select: select, limit: limit);
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
  Future insert(Map<String, dynamic> model) async {
    print(model);
    try {
      if (!model.containsKey(primaryKey) &&
          primaryKeyType != PrimaryKeyType.intAutoIncrement) {
        final String defaultPrimaryKey = _defaultValue();
        model[primaryKey] = defaultPrimaryKey;
      }
      final keys = [];
      final manyToManyKeys = [];
      model.keys.forEach((key) {
        if (fieldsKeys.contains(key) ||
            primaryKey == key ||
            (related.keys.contains(key) &&
                related[key]!["type"] == RelationShipType.oneToOne)) {
          keys.add(key);
        }
        if (related.keys.contains(key) &&
            related[key]!["type"] == RelationShipType.manyToMany) {
          manyToManyKeys.add(key);
        }
      });
      final values = [];
      keys.forEach((key) {
        if (related[key] != null) {
          final localKey = related[key]!["localKey"];
          if (model[key] != null) {
            values.add("'${model[key][localKey]}'");
          } else {
            values.add("null");
          }
        } else {
          values.add("'${model[key]}'");
        }
      });
      String query = "INSERT OR REPLACE INTO $tableName ";
      query = "$query (${keys.join(",")}) values(${values.join(",")})";
      // print("query $query");
      if (manyToManyKeys.isNotEmpty) {
        manyToManyKeys.forEach((key) {
          final objectt = model[key];
          print(objectt);
          if (objectt is List) {
            objectt.forEach((element) {
              final typeName = element["__typename"];
              _insertToWeakTable(key, model[primaryKey], element);
              _insertSpecificTable(typeName, element);
            });
          }
          if (objectt is Map) {
            final typeName = objectt["__typename"];
            _insertSpecificTable(typeName, Map<String, dynamic>.from(objectt));
          }
        });
      }
      // print(" query $query");
      (await db).rawInsert(query);
    } catch (e) {
      print(e.toString());
      print("Maybe duplicate");
      // print(e);
    }
  }

  insertWithoutPrimary(Map<String, dynamic> model) async {
    try {
      final keys = [];
      model.keys.forEach((key) {
        if (fieldsKeys.contains(key)) {
          keys.add(key);
        }
      });
      final values = keys.map((e) => "'${model[e]}'");
      final query = '''
    INSERT OR REPLACE INTO $tableName(${keys.join(",")})
    VALUES (${values.join(",")})
    ''';
      (await db).rawQuery(query);
    } catch (e) {
      print("inserWithoutPrimary in table.dart ${e.toString()}");
    }
  }

  _insertToWeakTable(
      String tableName, String strongKey, Map<String, dynamic> model) {
    switch (tableName) {
      case "members":
        switch (model["__typename"].toLowerCase()) {
          case "user":
            final primaryKey = userTable.primaryKey;
            memberTable.insertWithoutPrimary(
                {"user_id": model[primaryKey], "conversation_id": strongKey});
            break;
          default:
        }
        break;
      default:
        print("unknow table name");
    }
  }

  _insertSpecificTable(String typeName, Map<String, dynamic> model) {
    switch (typeName.toLowerCase()) {
      case "user":
        final table = userTable;
        table.insert(model);
        break;
      default:
        print("Not found typename");
    }
  }

  _generateUpdateQuery(Map<String, dynamic> model) {
    String query = '''
  UPDATE $tableName
  SET ${model.map((key, value) => MapEntry(key, "$key = '$value'")).values.join(",")}
  WHERE $primaryKey = '${model[primaryKey]}';
  ''';
    return query;
  }

  @override
  update(Map<String, dynamic> model) {
    return db.then((value) => value.execute(_generateUpdateQuery(model)));
  }

  // getMany(Map<String, dynamic> where) async {
  //   return db.then((value) => value.rawQuery(
  //       "SELECT * FROM $tableName WHERE ${where.keys.first} = '${where.values.first}'"));
  // }

  getAll() async {
    return db.then((value) => value.rawQuery("SELECT * FROM $tableName"));
  }

  @override
  delete() {}
}
