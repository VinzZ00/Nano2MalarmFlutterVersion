// ignore_for_file: prefer_const_constructors

import 'dart:async';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:replicanano2_malarm/core/services/geolocator.dart';

import 'package:replicanano2_malarm/data/usecases/googleAPI/ReverseGeoCoding.dart';
import 'package:replicanano2_malarm/data/usecases/googleAPI/getRoutes.dart';
import 'package:replicanano2_malarm/presenters/views/models/map_form_return.dart';

import '../../core/entities/places.dart';



class MapPage extends StatefulWidget {
  final GlobalKey<MapPageState> mapGlobalKey;

  const MapPage({super.key, required this.mapGlobalKey});

  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  ReverseGeocodingUsecase revGeoCode = ReverseGeocodingUsecase();
  GetRouteUsecase route = GetRouteUsecase();
  final Completer<GoogleMapController> _controller = Completer();
  Position? currDevicePosition;
  int estimatedTime = 0;
  Polyline? polyLine;

  Set<Marker> userMarker = <Marker>{};
  Place? userPlace;
  Place? destPlace;
  String transportType = "DRIVE";
  late GoogleMap map;

  void findRoute(Place userP, Place destP) async {
    var googleRoute = await route.getRoute(userP, destP, transportType);

    setState(() {
      polyLine = Polyline(
        polylineId: PolylineId("polyRoutes"), 
        color: CupertinoColors.activeBlue, 
        points: googleRoute.$1,
      );  

      estimatedTime = googleRoute.$2;
    });
  }

  Widget createMap() {
    GoogleMap map = GoogleMap(
        myLocationButtonEnabled: false,
        initialCameraPosition: CameraPosition(
          target: LatLng(0,0),
        ),
        onMapCreated: (controller) {
          _controller.complete(controller);
        },
        polylines: polyLine != null ? <Polyline>{polyLine!} : <Polyline>{},

        onLongPress : (latlong) async {
          var destPlace = await revGeoCode.call(latlong);
          destPlace.latNlong = latlong;
          this.destPlace = destPlace;
        
          Marker destinationMarker = Marker(
            markerId: MarkerId("destinationMarker"),
            position: this.destPlace?.latNlong ?? LatLng(0.0, 0.0),
            infoWindow: InfoWindow(
              title: this.destPlace?.name ?? ""
            )
          );

          setState(() {
            this.destPlace = destPlace;
            userMarker.add(destinationMarker);
            
            if (userPlace != null && this.destPlace != null) {
              findRoute(userPlace!, this.destPlace!);
            }

          });
        },
        markers: userMarker,

        /* MARK: drag user marker to change the user latlong if needed */ 
        // onCameraMove: (position) {
        //   setState(() {
        //     userMarker.add(Marker(markerId: MarkerId("UserMarker"), position : position.target, infoWindow: InfoWindow(title: "Your Current Position")));
        //   });
        // },
      );

    this.map = map;
    return map;
  }

  @override
  Widget build(BuildContext context) {
    
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Long press to select Place"),
        leading: CupertinoNavigationBarBackButton(),
        trailing: GestureDetector(
          onTap: () {
            if ((userMarker.map((e) => e.markerId).toSet()).containsAll({
              MarkerId("UserMarker"),
              MarkerId("destinationMarker")
            })) {
              userMarker.forEach((element) {
                print("usermarker IDs : ${element.markerId}");
                print("usermarker IDs : ${element.position}");
              });
              
              var destinationMarker = userMarker.firstWhere((m) => m.markerId == MarkerId("destinationMarker"));

              // ignore: unnecessary_this
              returnMapData data = returnMapData(stringValue: "", mapValue: {}, polyline: polyLine!,estimatedTime: this.estimatedTime);
              
              if (userPlace != null && destPlace != null) {
                
                data.stringValue = destinationMarker.infoWindow.title!;
                data.mapValue["user"] = (userPlace!, userMarker.firstWhere((m) => m.markerId == MarkerId("UserMarker")));
                data.mapValue["dest"] = (destPlace!, destinationMarker);

                print("mapval : ${data.mapValue}");
                print("stringValue : ${data.stringValue}");
                Navigator.pop(context, data);
              }
            }
            print("Done popping");
          },
          child: Text("Done"),
        ),
      ),
      child: Scaffold(
        // MARK: Google Map Code
        body: 
        // GoogleMap(
        //   myLocationButtonEnabled: false,
        //   initialCameraPosition: CameraPosition(
        //     target: LatLng(0,0),
        //   ),
        //   onMapCreated: (controller) {
        //     _controller.complete(controller);
        //   },
        //   polylines: polyLine != null ? <Polyline>{polyLine!} : <Polyline>{},

        //   onLongPress : (latlong) async {
        //     var destPlace = await revGeoCode.call(latlong);
        //     destPlace.latNlong = latlong;
        //     this.destPlace = destPlace;
          
        //     Marker destinationMarker = Marker(
        //       markerId: MarkerId("destinationMarker"),
        //       position: this.destPlace?.latNlong ?? LatLng(0.0, 0.0),
        //       infoWindow: InfoWindow(
        //         title: this.destPlace?.name ?? ""
        //       )
        //     );

        //     setState(() {
        //       this.destPlace = destPlace;
        //       userMarker.add(destinationMarker);
              
        //       if (userPlace != null && this.destPlace != null) {
        //         findRoute(userPlace!, this.destPlace!);
        //       }

        //     });
        //   },
        //   markers: userMarker,

        //   /* MARK: drag user marker to change the user latlong if needed */ 
        //   // onCameraMove: (position) {
        //   //   setState(() {
        //   //     userMarker.add(Marker(markerId: MarkerId("UserMarker"), position : position.target, infoWindow: InfoWindow(title: "Your Current Position")));
        //   //   });
        //   // },
        // ),
        createMap(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            getcurrentloc();
            if (destPlace != null) {
              findRoute(userPlace!, destPlace!);
            }
          },
          child: Icon(Icons.location_pin),
        ),
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

    var place = await revGeoCode.call(LatLng(retrievedLoc.latitude, retrievedLoc.longitude));
    setState(() {
      userPlace = place;
      currDevicePosition = retrievedLoc;
      // print("userMarker testing : ${}");
      print("true false : ${(!userMarker.map((e) => e.markerId == MarkerId("UserMarker")).isNotEmpty)}");
      if (!userMarker.map((e) => e.markerId == MarkerId("UserMarker")).isNotEmpty) {
        userMarker.removeWhere((e) => e.markerId == MarkerId("UserMarker"));
      }

      // userMarker = <Marker>{Marker(markerId: MarkerId("UserMarker"), position: LatLng(currDevicePosition!.latitude, currDevicePosition!.longitude))};
      userMarker.add(Marker(markerId: MarkerId("UserMarker"), position: LatLng(currDevicePosition!.latitude, currDevicePosition!.longitude), infoWindow: InfoWindow(title : (place.name != "") ? place.name : "Your Current Location")));
      print("marker lenght : ${userMarker.length}");
      
    });

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(currDevicePosition!.latitude, currDevicePosition!.longitude), zoom: 19))
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