import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import "dart:io" as io;

class DatabaseHelper {
  static Database? _db;
  static const String DB_NAME = "bebes";
  static const String ID = "_id";
  static const String USER_TABLE = "users";
  static const String CONVERSATION_TABLE = "conversations";
  static const String FRIENDSHIP_TABLE = "friendships";
  Future<Database> get db async {
    return _db ?? await initDb();
  }

  initDb() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, DB_NAME);
    Database db = await openDatabase(path, version: 1);
    return db;
  }

  _onCreate(Database db, int version) async {
    String sqlCreateUserTable =
        "CREATE TABLE IF NOT EXISTS user(_id        VARCHAR(36) NOT NULL PRIMARY KEY  ,name       VARCHAR(255)  ,username   VARCHAR(255)  ,email      VARCHAR(255)  ,phone      VARCHAR(30)  ,avatarUrl  VARCHAR(255)  ,birthday   VARCHAR(255)  ,lastOnline BIT  NOT NULL  ,gender     VARCHAR(4) NOT NULL  ,active     BIT  NOT NULL);";
    String sqlCreateConverstaionTable =
        "CREATE TABLE IF NOT EXISTS conversation(   _id         VARCHAR(36) NOT NULL,name        VARCHAR(255)  ,type        VARCHAR(30)  ,visible     BIT  NOT NULL  ,avatarUrl   VARCHAR(30)  ,isBlocked   BIT  NOT NULL  ,isDeleted   BIT  NOT NULL  ,deletedAt   VARCHAR(255)  ,createdAt   VARCHAR(255)  ,updatedAt   VARCHAR(255)  ,owner       VARCHAR(36)  ,blockBy     VARCHAR(36)  ,lastMessage VARCHAR(36)  ,friendShip  VARCHAR(36) PRIMARY KEY(_id)   FOREIGN KEY(friendShip) PREFERENCES        );";
    await db.execute(sqlCreateUserTable);
    await db.execute(sqlCreateConverstaionTable);
  }
}
