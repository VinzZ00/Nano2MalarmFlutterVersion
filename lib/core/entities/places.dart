import 'package:google_maps_flutter/google_maps_flutter.dart';

class Place {
  String name;
  LatLng latNlong;
  String placeId;

  Place({required this.name, required this.latNlong, required this.placeId});

  factory Place.fromJson(Map<String, dynamic> json) {
    print("name : ${json['result']['name']}");
    print('latlong : ${LatLng(json['result']['geometry']['location']['lat'], json['result']['geometry']['location']['lng'])}');
    print("placeId : ${json['result']['place_id']}");

    return Place(
      name: json['result']['name'],
      latNlong: LatLng(json['result']['geometry']['location']['lat'], json['result']['geometry']['location']['lng']), 
      placeId: json['result']['place_id']
      );
  }
} 