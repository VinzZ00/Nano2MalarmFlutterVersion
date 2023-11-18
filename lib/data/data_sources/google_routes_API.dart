import 'package:replicanano2_malarm/core/constant/google_key_constant.dart';
import 'package:replicanano2_malarm/core/entities/places.dart';
import 'package:replicanano2_malarm/core/entities/routes.dart';
import 'package:replicanano2_malarm/core/services/api_service.dart';

abstract class GoogleRoutesAbs {
  String baseUrl = "https://routes.googleapis.com/directions/v2:computeRoutes";
  Map<String, String> headers = {
    'Content-Type': 'application/json', // Return Json type
    'X-Goog-Api-Key': GoogleAPIKey.key, //API Key
    'X-Goog-FieldMask': 'routes.duration,routes.distanceMeters,routes.polyline.encodedPolyline', // Field masking or else will be overwhelmed
  };

  Future<GoogleRoute>getRoute(Place origin, Place destination, String transportType);

}

class GoogleRoutesApiDataSource extends GoogleRoutesAbs {

  late APIService apiService;

  GoogleRoutesApiDataSource() {
    apiService = APIService(super.baseUrl);
  }

  Future<GoogleRoute>getRoute(Place origin, Place destination, String transportType) async {
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
      "travelMode": transportType,
      "routingPreference": "ROUTING_PREFERENCE_UNSPECIFIED",
      "computeAlternativeRoutes": false,
      "routeModifiers": {
        "avoidTolls": false,
        "avoidHighways": false,
        "avoidFerries": false
      }
    };

    var response = await apiService.postRequest("", super.headers, body);
    print("done request from sources");
    print("response : ${response}");
    print("Response generated to Google route : ${GoogleRoute.fromJson(response)}");
    
    return GoogleRoute.fromJson(response);
  }

}