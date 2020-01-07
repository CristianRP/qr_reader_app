import 'dart:async';

import 'package:qr_reader_app/src/data/models/scan_model.dart';

class Validator {
  final geoValidator = StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
    handleData: (scans, sink) {
      final geoScans = scans.where((s) => s.type == 'geo').toList();
      sink.add(geoScans);
    }
  );

  final httpValidator = StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
    handleData: (scans, sink) {
      final httpScans = scans.where((s) => s.type == 'http').toList();
      sink.add(httpScans);
    }
  );
}