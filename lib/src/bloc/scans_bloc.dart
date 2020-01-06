import 'dart:async';

import 'package:qr_reader_app/src/data/scripts/scan_script.dart';
import 'package:qr_reader_app/src/providers/db_provider.dart';

class ScansBloc {
  static final ScansBloc _singleton = ScansBloc._internal();

  factory ScansBloc() {
    return _singleton;
  }

  ScansBloc._internal() {
    // get scans on the DB
    getScans();
  }

  final _scansController = StreamController<List<ScanModel>>.broadcast();

  Stream<List<ScanModel>> get scansStream => _scansController.stream;

  getScans() async {
    _scansController.sink.add( await ScanScript.getAllScans(DBProvider.db.database ) );
  }

  addScan( ScanModel scanModel ) async {
    await ScanScript.newScan(scanModel, DBProvider.db.database);
    getScans();
  }

  deleteScan( int id ) async {
    await ScanScript.deleteScan(id, DBProvider.db.database);
    getScans();
  }

  deleteAll() async {
    await ScanScript.deleteAll(DBProvider.db.database);
    getScans();
    //_scansController.sink.add( [] );
  }

  dispose() {
    _scansController?.close();
  }

}