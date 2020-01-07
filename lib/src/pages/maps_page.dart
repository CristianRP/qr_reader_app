import 'package:flutter/material.dart';
import 'package:qr_reader_app/src/bloc/scans_bloc.dart';
import 'package:qr_reader_app/src/providers/db_provider.dart';
import 'package:qr_reader_app/src/utils/utils.dart' as utils;

class MapsPage extends StatefulWidget {

  final String scanType;

  MapsPage({this.scanType});

  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  final scansBloc = ScansBloc();

  Stream<List<ScanModel>> scanStream;
  IconData iconData;

  @override
  Widget build(BuildContext context) {

    _determineStreamAndIcon();

    scansBloc.getScans();
    return StreamBuilder<List<ScanModel>>(
        stream: scanStream,
        builder: (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              final scans = snapshot.data;
              if (scans.length == 0) return Center(child: Text('No data to show'));

              return ListView.builder(
                  itemCount: scans.length,
                  itemBuilder: (context, i) => Dismissible(
                        key: UniqueKey(),
                        background: Container(color: Theme.of(context).accentColor),
                        child: ListTile(
                          leading: Icon(iconData,
                              color: Theme.of(context).primaryColor),
                          title: Text(scans[i].value),
                          subtitle: Text(scans[i].id.toString()),
                          trailing:
                              Icon(Icons.keyboard_arrow_right, color: Colors.grey),
                          onTap: () => utils.launchURL(scans[i], context),
                        ),
                        onDismissed: (DismissDirection dismissDirection) {
                          //ScanScript.deleteScan(scans[i].id, DBProvider.db.database);
                          scansBloc.deleteScan(scans[i].id);
                        },
                      ));
        });
  }

  _determineStreamAndIcon() {
    if (widget.scanType == 'geo') {
      scanStream = scansBloc.scansStream;
      iconData = Icons.map;
    } else if (widget.scanType == 'http') {
      scanStream = scansBloc.scansStreamHttp;
      iconData = Icons.alternate_email;
    }
    setState(() {});
  }

}
