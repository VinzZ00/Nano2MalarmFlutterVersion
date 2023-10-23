import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:replicanano2_malarm/core/services/geolocator.dart';

class mapPage extends StatefulWidget {
  const mapPage({super.key});

  @override
  State<mapPage> createState() => _mapPageState();
}

class _mapPageState extends State<mapPage> {

  Position? currDevicePosition;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Map"),
        leading: CupertinoNavigationBarBackButton()
        ),
      child: Center(
        heightFactor: 0.9,
        child: renderMap()
        )
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getcurrentloc();
  }

  Widget renderMap() {
    if (currDevicePosition != null ) {
      return GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            currDevicePosition!.latitude,
            currDevicePosition!.longitude
          ),
        ),
      );
    } else {
      currDevicePosition = Position(longitude: 0.0, latitude: 0.0, timestamp: DateTime.timestamp(), accuracy: 0.0, altitude: 0.0, altitudeAccuracy: 0.0, heading: 0.0, headingAccuracy: 0.0, speed: 0.0, speedAccuracy: 0.0);
      return GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            currDevicePosition!.latitude,
            currDevicePosition!.longitude
          ),
        ),
      );
    }
  }

 

  void getcurrentloc() async {
    var retrievedLoc = await determinePosition();

    setState(()  {
      currDevicePosition = retrievedLoc;
      print("latitude ${currDevicePosition!.latitude}, longitude ${currDevicePosition!.longitude}, accuracy ${currDevicePosition!.accuracy}");
    });
  }
}