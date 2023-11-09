import 'package:replicanano2_malarm/core/constant/google_key_constant.dart';
import 'package:replicanano2_malarm/core/entities/places.dart';
import 'package:replicanano2_malarm/core/entities/routes.dart';
import 'package:replicanano2_malarm/core/services/api_service.dart';

class GoogleRoutesAbs {
  String baseUrl = "https://routes.googleapis.com/directions/v2:computeRoutes";
  Map<String, String> headers = {
    'Content-Type': 'application/json', // Return Json type
    'X-Goog-Api-Key': GoogleAPIKey.key, //API Key
    'X-Goog-FieldMask': 'routes.duration,routes.distanceMeters,routes.polyline.encodedPolyline', // Field masking or else will be overwhelmed
  };



}

class GoogleRoutesApiDataSource extends GoogleRoutesAbs {

  late APIService apiService;

  GoogleRoutesApiDataSource() {
    apiService = APIService(super.baseUrl);
  }

  Future<GoogleRoute>getRoute(Place origin, Place destination) async {
    Map<String, dynamic> body = 
    {
      "origin": {
          "location": {
              "latLng": {
                "latitude": origin.latNlong.latitude,
                "longitude": origin.latNlong.longitude
              }
          }
      },
      "destination": {
          "location": {
              "latLng": {
                "latitude": destination.latNlong.latitude,
                "longitude": destination.latNlong.longitude
              }
          }
      },
      "travelMode": "DRIVE",
      "routingPreference": "TRAFFIC_AWARE",
      "departureTime": "2023-11-10T15:01:23.045123456Z",
      "computeAlternativeRoutes": false,
      "routeModifiers": {
        "avoidTolls": false,
        "avoidHighways": false,
        "avoidFerries": false
      }
    };

    var response = await apiService.postRequest("", super.headers, body);
    print("done request from sources");
    return GoogleRoute.fromJson(response);
  }

}