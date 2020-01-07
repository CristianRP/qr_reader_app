import 'package:flutter/material.dart';
import 'package:qr_reader_app/src/bloc/scans_bloc.dart';
import 'package:qr_reader_app/src/providers/db_provider.dart';
import 'package:qr_reader_app/src/utils/utils.dart' as utils;

class MapsPage extends StatelessWidget {
  final scansBloc = ScansBloc();

  @override
  Widget build(BuildContext context) {
    scansBloc.getScans();
    return StreamBuilder<List<ScanModel>>(
        stream: scansBloc.scansStream,
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
                          leading: Icon(Icons.cloud_queue,
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
}
