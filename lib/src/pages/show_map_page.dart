import 'package:flutter/material.dart';
import 'package:qr_reader_app/src/data/models/scan_model.dart';

class ShowMapPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final ScanModel scan = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Coordinates'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: (){},
          )
        ],
      ),
      body: Center(
        child: Text(scan.value),
      ),
    );
  }
}