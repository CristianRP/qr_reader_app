import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
export 'package:qr_reader_app/src/data/models/scan_model.dart';
import 'package:qr_reader_app/src/data/scripts/scan_script.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;

    // If the database instance is null then create new one
    _database = await initDB();

    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'scans.db');
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute(
          ScanScript.createTable
        );
      }
    );
  }

}