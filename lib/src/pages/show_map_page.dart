import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:qr_reader_app/src/data/models/scan_model.dart';

class ShowMapPage extends StatefulWidget {

  @override
  _ShowMapPageState createState() => _ShowMapPageState();
}

class _ShowMapPageState extends State<ShowMapPage> {
  final MapController mapController = MapController();

  String mapType = 'streets';

  @override
  Widget build(BuildContext context) {
    final ScanModel scan = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Coordinates'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: () {
              mapController.move(scan.getLatLng(), 15);
            },
          )
        ],
      ),
      body: _buildFlutterMap(scan),
      floatingActionButton: _buildChangeMapTypeButton(context),
    );
  }

  FloatingActionButton  _buildChangeMapTypeButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.repeat),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () {
        // streets, dark, light, outdoors, satellite
        if ( mapType == 'streets' ) {
          mapType = 'dark';
        } else if (mapType == 'dark') {
          mapType = 'light';
        } else if (mapType == 'light') {
          mapType = 'outdoors';
        } else if (mapType == 'outdoors') {
          mapType = 'satellite';
        } else {
          mapType = 'streets';
        }
        setState(() {});
      },
    );
  }

  Widget _buildFlutterMap(ScanModel scanModel) {
    // API KEY: pk.eyJ1IjoiY3Jpc3RpYW5ycCIsImEiOiJjazUzMGRtcWswM2t4M2ttZzJzNmU0ZzQ2In0.dyUzOG2AFo4engKd_dkDJw
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        center: scanModel.getLatLng(),
        zoom: 15
      ),
      layers: [
        _buildMap(),
        _buildMarkers(scanModel)
      ],
    );
  }

  LayerOptions _buildMap() {
    String _apiKey = 'pk.eyJ1IjoiY3Jpc3RpYW5ycCIsImEiOiJjazUzMGRtcWswM2t4M2ttZzJzNmU0ZzQ2In0.dyUzOG2AFo4engKd_dkDJw';
    return TileLayerOptions(
      urlTemplate: 'https://api.mapbox.com/v4/'
      '{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
      additionalOptions: {
        'accessToken'  : _apiKey,
        'id': 'mapbox.$mapType' // streets, dark, light, outdoors, satellite
      }
    );
  }

  MarkerLayerOptions _buildMarkers(ScanModel scanModel) {
    return MarkerLayerOptions(
      markers: <Marker> [
        Marker(
          width: 100.0,
          height: 100.0,
          point: scanModel.getLatLng(),
          builder: (context) => Container(
            child: Icon(Icons.location_on, size: 70.0, color: Theme.of(context).accentColor)
          )
        )
      ]
    );
  }
}