import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_reader_app/src/bloc/scans_bloc.dart';
import 'package:qr_reader_app/src/data/models/scan_model.dart';
import 'package:qr_reader_app/src/pages/directions_page.dart';
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

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: scansBloc.deleteAll,
          )
        ],
      ),
      body: _callPage(currentIndex),
      bottomNavigationBar: _buildCustomBottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        onPressed: _scanQR,
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  _scanQR() async {

    // https://flutter.dev/docs
    // geo:40.74088312736182,-73.97023573359377

    String futureString = 'https://flutter.dev/docs';

    //try {
    //  futureString = await BarcodeScanner.scan();
    //} catch (e) {
    //  futureString = e.toString();
    //}
    //print('Future String: $futureString');

    if (futureString != null) {
      final scan = ScanModel(value: futureString);
      //ScanScript.newScan(scan, DBProvider.db.database);
      scansBloc.addScan(scan);

      final scan2 = ScanModel(value: 'geo:40.74088312736182,-73.97023573359377');
      //ScanScript.newScan(scan, DBProvider.db.database);
      scansBloc.addScan(scan2);

      if ( Platform.isIOS ) {
        Future.delayed(Duration(milliseconds: 750), () {
          utils.launchURL(scan);
        });
      } else {
        utils.launchURL(scan);
      }
    }

  }

  Widget _callPage(int actualPage) {
    switch (actualPage) {
      case 0: return MapsPage();
        break;
      case 1: return DirectionsPage();
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