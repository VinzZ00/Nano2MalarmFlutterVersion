class CustRecord {
  String id = "";
  double latitude = 0.0, longitude = 0.0;
  String description = '';
  bool complete = false;
  DateTime date = DateTime.now();
  
  CustRecord(this.id, this.latitude, this.longitude, this.description, this.date, this.complete);

  Map<String, Object> toMap() => 
  {
    'id' : id,
    'latitude' : latitude,
    'longitude' : longitude, 
    'date' : date,
    'complete' : complete == true ? 1 : 0
  };

  CustRecord fromMap(Map<dynamic, dynamic> map) {
    id = map['id'] as String;
    latitude = map['latitude'] as double;
    longitude = map['longitude'] as double;
    description = map['description'] as String;
    date = map['date'] as DateTime;
    complete = (map['complete'] as int == 1 ? true : false);
    return CustRecord(id, latitude, longitude, description, date, complete);
  }

}