import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:replicanano2_malarm/core/constant/google_key_constant.dart';
import 'package:replicanano2_malarm/core/entities/places.dart';
import 'package:replicanano2_malarm/core/services/api_service.dart';



abstract class GoogleGeocodingAbs {
  String baseUrl = "https://maps.googleapis.com";  
  Future<String>reverseGeoCoding(LatLng latlong);
  Future<String>forwardGeoCoding(String searchText);
  Future<Place>getPlaceDetail(String place_id);
}


class GoogleGeocodingDataSource extends GoogleGeocodingAbs {
  
  String apiKey = GoogleAPIKey.key;
  late APIService apiServe;

  GoogleGeocodingDataSource() {
    apiServe = APIService(baseUrl);
  }

  Future<String>reverseGeoCoding(LatLng latlong) async {
    String mapAPIEndPoint = "maps/api/geocode/json";

    Map<String, dynamic> revGeoCode = await apiServe.fetchAndWait({
      "key" : apiKey,
      "latlng"  : "${latlong.latitude}, ${latlong.longitude}"
    }, mapAPIEndPoint);
    print("Place Id : ${revGeoCode["results"][0]["place_id"]}");
    return (revGeoCode["results"][0]["place_id"]);
  }
  
  @override
  Future<String> forwardGeoCoding(String searchText) {
    // TODO: implement ForwardGeoCoding
    throw UnimplementedError();
  }
  
  @override
  Future<Place> getPlaceDetail(String place_id) async {
    // TODO: implement getPlaceDetail
    String placeDetailEndPoint = 'maps/api/place/details/json';

    Map<String, dynamic> placeDetail = await apiServe.fetchAndWait({
      "key": apiKey,
      "place_id": place_id
    }, placeDetailEndPoint);
    print("Masuk ke get Place Detail ");
    print(" Place Object : ${Place.fromJson(placeDetail)}, Place Name : ${Place.fromJson(placeDetail).name}");
    return Place.fromJson(placeDetail);

  }
}



