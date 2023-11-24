import 'package:google_maps_flutter/google_maps_flutter.dart';

class Place {
  String name;
  LatLng latNlong;
  String placeId;

  Place({required this.name, required this.latNlong, required this.placeId});

  factory Place.fromJson(Map<String, dynamic> json) {
    print("name : ${json['result']['name']}");
    print("lat : ${(json['result']['geometry']['location']['lat']).runtimeType}");
    print('latlong : ${LatLng(json['result']['geometry']['location']['lat'] + 0.0, json['result']['geometry']['location']['lng'] + 0.0)}');
    print("placeId : ${json['result']['place_id']}");

    return Place(
      name: json['result']['name'],
      latNlong: LatLng(json['result']['geometry']['location']['lat'] + 0.0, json['result']['geometry']['location']['lng'] + 0.0), 
      placeId: json['result']['place_id']
      );
  }
} 