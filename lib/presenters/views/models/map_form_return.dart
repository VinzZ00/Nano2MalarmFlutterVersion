import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:replicanano2_malarm/core/entities/places.dart';

class returnMapData {
  String stringValue;
  Map<String, (Place, Marker)> mapValue;
  Polyline? polyline;

  returnMapData({
    required this.stringValue,
    required this.mapValue,
    required this.polyline
  });
}