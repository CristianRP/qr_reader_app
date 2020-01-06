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

  static final String TABLE_NAME = 'scans';
  static final String ID = 'id';
  static final String TYPE = 'type';
  static final String VALUE = 'value';
}
