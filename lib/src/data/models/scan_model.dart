import 'package:latlong/latlong.dart';

class ScanModel {
  int id;
  String type;
  String value;

  ScanModel({
    this.id,
    this.type,
    this.value,
  }){
    if (value.contains('http'))
      type = 'http';
    else
      type = 'geo';
  }

  factory ScanModel.fromJson(Map<String, dynamic> json) => ScanModel(
        id    : json["id"],
        type  : json["type"],
        value : json["value"],
      );

  Map<String, dynamic> toJson() => {
        "id"    : id,
        "type"  : type,
        "value" : value,
      };

  LatLng getLatLng() {
    final latLng = value.substring(4).split(',');
    final lat = double.parse(latLng[0]);
    final lng = double.parse(latLng[1]);
    return LatLng(lat, lng);
  }

  static final String TABLE_NAME = 'scans';
  static final String ID = 'id';
  static final String TYPE = 'type';
  static final String VALUE = 'value';
}
