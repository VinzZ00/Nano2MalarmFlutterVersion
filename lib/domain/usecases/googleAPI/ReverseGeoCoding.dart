import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:replicanano2_malarm/core/entities/places.dart';
import 'package:replicanano2_malarm/data/repository/remoteAPIRepository.dart';

class ReverseGeocodingUsecase {
  RemoteAPIRepository repo = RemoteAPIRepository();

  Future<Place>call(LatLng latlong) async {
    var placeId =  await repo.googleGeoCodingDatasource.reverseGeoCoding(latlong);
    return await repo.googleGeoCodingDatasource.getPlaceDetail(placeId);
  }
}