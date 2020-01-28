import 'package:qr_reader_app/src/data/models/scan_model.dart';
import 'package:sqflite/sqflite.dart';

class ScanScript {
  static final String createTable = '''
                        CREATE TABLE ${ScanModel.TABLE_NAME} (
                          ${ScanModel.ID} INTEGER PRIMARY KEY,
                          ${ScanModel.TYPE} TEXT,
                          ${ScanModel.VALUE} TEXT
                        )
                       ''';

  // Create registers
  static newScanRaw( ScanModel scanModel, Future<Database> database ) async {
    final db = await database;
    final response = await db.rawInsert(
      '''INSERT INTO $ScanModel.TABLE_NAME(ID, TYPE, VALUE)
      VALUES (${scanModel.id}, "${scanModel.type}", "${scanModel.value})"'''
    );
    return response;
  }

  static newScan(ScanModel scanModel, Future<Database> database) async {
    final db = await database;
    final response = await db.insert(ScanModel.TABLE_NAME, scanModel.toJson());
    return response;
  }

  static Future<ScanModel> getScanId(int id, Future<Database> database) async {
    final db = await database;
    final response = await db.query(ScanModel.TABLE_NAME, where: '${ScanModel.ID} = ?', whereArgs: [id]);
    return response.isNotEmpty ? ScanModel.fromJson(response.first) : [];
  }

  static Future<List<ScanModel>> getAllScans(Future<Database> database) async {
    final db = await database;
    final response = await db.query(ScanModel.TABLE_NAME);
    List<ScanModel> scanModelList = response.isNotEmpty ? response.map((sm) => ScanModel.fromJson(sm)).toList() : [];
    return scanModelList;
  }

  static Future<List<ScanModel>> getAllScansByType(String type, Future<Database> database) async {
    final db = await database;
    final response = await db.query(ScanModel.TABLE_NAME, where: '${ScanModel.TYPE} = ?', whereArgs: [type]);
    List<ScanModel> scanModelList = response.isNotEmpty ? response.map((sm) => ScanModel.fromJson(sm)).toList() : [];
    return scanModelList;
  }

  static Future<int> updateScan(ScanModel scanModel, Future<Database> database) async {
    final db = await database;
    final response = await db.update(ScanModel.TABLE_NAME, scanModel.toJson(), where: '${ScanModel.ID} = ?', whereArgs: [scanModel.id]);
    return response;
  }

  static Future<int> deleteScan(int id, Future<Database> database) async {
    final db = await database;
    return await db.delete(ScanModel.TABLE_NAME, where: '${ScanModel.ID} = ?', whereArgs: [id]);
  }

  static Future<int> deleteAll(Future<Database> database) async {
    final db = await database;
    return await db.delete(ScanModel.TABLE_NAME);
  }

  static Future<int> deleteByType(Future<Database> database, String type) async {
    final db = await database;
    return await db.delete(ScanModel.TABLE_NAME, where: '${ScanModel.TYPE} = ?', whereArgs: [type]);
  }
}