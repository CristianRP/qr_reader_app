import 'package:flutter/material.dart';
import 'package:qr_reader_app/src/bloc/scans_bloc.dart';
import 'package:qr_reader_app/src/data/models/scan_model.dart';
import 'package:qr_reader_app/src/utils/utils.dart' as utils;

class DirectionsPage extends StatelessWidget {

  final scansBloc = ScansBloc();

  @override
  Widget build(BuildContext context) {

    scansBloc.getScans();
    return StreamBuilder<List<ScanModel>>(
      stream: scansBloc.scansStreamHttp,
      builder: (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator()
          );
        }

        final snaps = snapshot.data;
        if (snaps.length == 0) return Center(child: Text('No data to show :('));

        return ListView.builder(
          itemCount: snaps.length,
          itemBuilder: (BuildContext context, int i) => Dismissible(
            key: UniqueKey(),
            background: Container(color: Theme.of(context).accentColor),
            child: ListTile(
              leading: Icon(Icons.alternate_email, color: Theme.of(context).accentColor),
              title: Text(snaps[i].value),
              subtitle: Text(snaps[i].id.toString()),
              trailing: Icon(Icons.keyboard_arrow_right, color: Colors.grey),
              onTap: () => utils.launchURL(snaps[i], context)
            ),
            onDismissed: (direction) {
              scansBloc.deleteScan(snaps[i].id);
            },
          ),
        );
      },
    );
  }
}