import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import "dart:io" as io;
import 'package:sqflite/sqflite.dart';

class BebesDatabase {
  Database? _db;
  final String _name;
  BebesDatabase(this._name);
  Future<Database> get db async {
    return _db ?? await onInit();
  }

  Future<Database> onInit() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "$_name.db");
    Database db = await openDatabase(path, version: 1);
    return db;
  }
}
