
import 'package:replicanano2_malarm/data/data_sources/google_geocoding_API.dart';
import 'package:replicanano2_malarm/data/data_sources/google_routes_API.dart';

class RemoteAPIRepository {
  GoogleGeocodingDataSource googleGeoCodingDatasource = GoogleGeocodingDataSource();
  GoogleRoutesApiDataSource googleRouteDataSource = GoogleRoutesApiDataSource();
}