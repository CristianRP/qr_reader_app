import 'dart:io';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:qr_reader_app/src/bloc/scans_bloc.dart';
import 'package:qr_reader_app/src/data/models/scan_model.dart';
import 'package:qr_reader_app/src/pages/maps_page.dart';

import 'package:qr_reader_app/src/providers/db_provider.dart';
import 'package:qr_reader_app/src/utils/utils.dart' as utils;

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final scansBloc = ScansBloc();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  int currentIndex = 0;
  String scanType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () => scansBloc.deleteByType(scanType),
          )
        ],
      ),
      body: _callPage(currentIndex),
      bottomNavigationBar: _buildCustomBottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        onPressed: () => _scanQR(context),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  _scanQR(BuildContext context) async {

    // https://flutter.dev/docs
    // geo:40.74088312736182,-73.97023573359377

    String futureString;
    bool hasError;

    try {
      futureString = await BarcodeScanner.scan();
      hasError = false;
    } catch (e) {
      futureString = e.toString();
      hasError = true;
    }
    print('Future String: $futureString');

    if (futureString != null && !hasError) {
      final scan = ScanModel(value: futureString);
      //ScanScript.newScan(scan, DBProvider.db.database);
      scansBloc.addScan(scan);

      if ( Platform.isIOS ) {
        Future.delayed(Duration(milliseconds: 750), () {
          utils.launchURL(scan, context);
        });
      } else {
        utils.launchURL(scan, context);
      }
    } else {
      print('No data to save');
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text('Scaned was canceled'))
      );
    }

  }

  Widget _callPage(int actualPage) {
    switch (actualPage) {
      case 0:
        scanType = 'geo';
        return MapsPage(scanType: scanType);
        break;
      case 1:
        scanType = 'http';
        return MapsPage(scanType: scanType);
        break;
      default:
        return MapsPage();
    }
  }

  BottomNavigationBar _buildCustomBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          title: Text('Maps'),
          icon: Icon(Icons.map)
        ),
        BottomNavigationBarItem(
          title: Text('Directions'),
          icon: Icon(Icons.brightness_5)
        )
      ],
    );
  }
}