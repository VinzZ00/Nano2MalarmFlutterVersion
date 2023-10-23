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
      navigationBar: CupertinoNavigationBar(
        middle: const Text("Map"),
        leading: CupertinoButton(
          child: const Text("Back"), 
          onPressed: () {
            Navigator.pop(context);
          })
        ),
      child: Scaffold(
        body: FloatingActionButton(
          onPressed: () {
            getcurrentloc();
          },
          child: const Icon(Icons.location_pin)
        ),
      )
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getcurrentloc();
  }

  void getcurrentloc() async {
    setState(() async {
      currDevicePosition =  await determinePosition();  
    });
  }
}