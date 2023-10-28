// ignore_for_file: prefer_const_constructors

import 'dart:async';

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
  final Completer<GoogleMapController> _controller = Completer();
  Position? currDevicePosition;
  
  Set<Marker> userMarker = <Marker>{Marker(markerId: MarkerId("UserMarker"))};


  
  @override
  Widget build(BuildContext context) {

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Map"),
        leading: CupertinoNavigationBarBackButton()
      ),
      child: Scaffold(
        // heightFactor: 0.9,
        body: GoogleMap(
          myLocationButtonEnabled: false,
          initialCameraPosition: CameraPosition(
            target: LatLng(
              0,
              0
            ),
          ),
          onMapCreated: (controller) {
            _controller.complete(controller);
          },
          markers: userMarker
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print("Clicked");
            getcurrentloc();
          },
          child: Icon(Icons.location_pin),
        )
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getcurrentloc();
  } 

  void getcurrentloc() async {
    var retrievedLoc = await determinePosition();

    setState(()  {
      currDevicePosition = retrievedLoc;
      userMarker = <Marker>{Marker(markerId: MarkerId("UserMarker"), position: LatLng(currDevicePosition!.latitude, currDevicePosition!.longitude))};
    });

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(currDevicePosition!.latitude, currDevicePosition!.longitude), zoom: 12))
    );
  }

  Future<void> _disposeController() async {
    final GoogleMapController controller = await _controller.future;
    controller.dispose();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _disposeController();
    super.dispose();
  }
}