// ignore_for_file: prefer_const_constructors




import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:replicanano2_malarm/data/usecases/getRoutes.dart';
import 'package:replicanano2_malarm/presenters/views/map_view.dart';
import 'package:replicanano2_malarm/presenters/views/models/map_form_return.dart';






class FormPage extends StatefulWidget {
  // final GlobalKey<MapPageState> mapGlobalKey;
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  
  final List<String> transporationType = ["Drive", "Bicylce", "Walk", "Motor Cycle"];
  String selectedTypeTrans = "Drive";
  late GlobalKey<MapPageState> mapGlobalKey;
  // GoogleMap? map;
  // Marker? userLoc;
  // Marker? destLoc;
  // Place? userPlace;
  // Place? destPlace;
  // String? destName;
  
  DateTime selectedDate = DateTime(2023, 10, 18, 16, 36);
  var eventNameTextController = TextEditingController(text: "");
  var descriptionTextController = TextEditingController(text: "");

  void _showDialog(Widget child, double size) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: size,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system
        // navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }
  // MARK: Map resource.
  Set<Marker> markers = {Marker(markerId: MarkerId("UserMarker")), Marker(markerId: MarkerId("destinationMarker"))};
  returnMapData? mapRes;
  GoogleMap? map;
  final Completer<GoogleMapController> _controller = Completer();

  GetRouteUsecase getRoute = GetRouteUsecase();


  void generateMap() {
    
    print("User Marker : ${markers.firstWhere((element) => element.markerId == MarkerId("UserMarker"))}");
      var map = GoogleMap(
        initialCameraPosition: CameraPosition(target: mapRes!.mapValue["user"]!.$1.latNlong),
        markers: markers,
        polylines: mapRes!.polyline != null ? <Polyline>{mapRes!.polyline!} : <Polyline>{},
        onMapCreated: (controller) => _controller.complete(controller),
        zoomControlsEnabled: true,
        myLocationButtonEnabled: false,
      );
     


      setState(() {
        this.map = map;
        if (mapRes!.mapValue["user"] != null) {
          print("Marker Returned : ${mapRes!.mapValue["user"]!.$2}");
          markers.add(mapRes!.mapValue["user"]!.$2);
        }

        if (mapRes!.mapValue["dest"] != null) {
          markers.add(mapRes!.mapValue["dest"]!.$2);
        }
      });

    animateCamera(mapRes!.mapValue["user"]!.$1.latNlong);

  }
  
  void animateCamera(LatLng userLoc) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: userLoc, zoom: 19))
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      navigationBar: CupertinoNavigationBar(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "Fill your to do list form",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500
              ),
            ),
          ],
        ),
        trailing: GestureDetector(
          onTap: () {},
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "Done",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: CupertinoColors.activeBlue,
                ),
              ),
            ],
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: SafeArea(
          child: Column(
            children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: CupertinoTextField(
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    controller: eventNameTextController,
                    placeholder: "Event",
                    placeholderStyle: TextStyle(color: (MediaQuery.of(context).platformBrightness == Brightness.dark) ? Colors.grey[600] : Colors.black),
                  ),
                ),
      
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text("Select Time",
                        style: TextStyle(
                          fontSize: 20
                        ),),
                      ),
                      Expanded(
                        flex: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CupertinoButton(
                              onPressed: () => _showDialog(
                                CupertinoDatePicker (
                                initialDateTime: selectedDate,
                                use24hFormat: true,
                                mode: CupertinoDatePickerMode.dateAndTime,
                                onDateTimeChanged: (value) {
                                  setState(() => selectedDate = value);
                                  },
                                ), 216
                              ),
                              child: Text(
                                '${selectedDate.month}-${selectedDate.day}-${selectedDate.year} ${selectedDate.hour}:${selectedDate.minute}',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: (MediaQuery.of(context).platformBrightness == Brightness.dark) ? Colors.grey[400] : Colors.black
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                

                CupertinoButton(
                  onPressed: () async {
                    
                    var result = await Navigator.of(context).push(
                      CupertinoModalPopupRoute(
                        builder: (context) => MapPage(mapGlobalKey: GlobalKey(debugLabel: "GlobalMap"))
                        )
                    );

                    // var result = await Navigator.pushNamed(context, "/form/map");
      
                    setState(() {
                      if (result is returnMapData) {
                        // destName = result.stringValue;
                        // Polyline
                        // if (result.mapValue["user"] != null) {
                        //   userLoc = result.mapValue["user"]!.$2;
                        //   userPlace = result.mapValue["user"]!.$1;
                        // } else {
                        //   print("Userplace is null");
                        // }

                        // if (result.mapValue["dest"] != null) {
                        //   destPlace = result.mapValue["dest"]!.$1;
                        //   destLoc = result.mapValue["dest"]!.$2;
                        // }

                        this.mapRes = result;

                        setState(() {
                          generateMap();
                        });
                      }
                    });

                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: (MediaQuery.of(context).platformBrightness == Brightness.dark)  ? Colors.grey[800] : Colors.grey[400]
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                              child: Icon(CupertinoIcons.location_solid, color: (MediaQuery.of(context).platformBrightness == Brightness.dark) ? Colors.grey[400] : Colors.grey[700]),
                              ),
                              Text(
                                (mapRes != null) ? mapRes!.stringValue :
                                "Point on map on where you wanna go",
                                style: TextStyle(color: (MediaQuery.of(context).platformBrightness == Brightness.dark) ? Colors.grey[400] : Colors.black),
                              ),
                            ],
                          ),
                    ),
                  )
                ),
                
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: CupertinoTextField(
                    maxLines: 8,
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    controller: descriptionTextController,
                    placeholder: "Description",
                    placeholderStyle: TextStyle(color: (MediaQuery.of(context).platformBrightness == Brightness.dark) ? Colors.grey[600] : Colors.black),
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                  ),
                ),

                Column(
                  children: [
                    (map != null) ? Padding(
                      padding: const EdgeInsets.fromLTRB(16,10,16,0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                        height: 280,
                        child: map!
                      ),
                      )
                    ) : 
                    SizedBox.shrink(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                          child: (mapRes?.estimatedTime != null) ? Text("Estimated Time : ${mapRes!.estimatedTime} ${(mapRes!.estimatedTime > 1 ? "seconds" : "second")}") : SizedBox.shrink()
                          ),

                        // Expanded(
                        //   flex: 2,
                        //   child: 
                        CupertinoButton(
                            child: Text(
                              selectedTypeTrans, 
                              style: TextStyle(
                                color: CupertinoColors.activeBlue, 
                                fontWeight: FontWeight.w600,
                                fontSize: 20
                              )
                            ), 
                            onPressed: (){
                              showCupertinoModalPopup<void>(
                                context: context,
                                builder: (BuildContext context) => Container(
                                  height: 216,
                                  padding: const EdgeInsets.only(top: 6.0),
                                    // The Bottom margin is provided to align the popup above the system
                                    // navigation bar.
                                  margin: EdgeInsets.only(
                                    bottom: MediaQuery.of(context).viewInsets.bottom,
                                  ),
                                  // Provide a background color for the popup.
                                  color: CupertinoColors.systemBackground.resolveFrom(context),
                                  // Use a SafeArea widget to avoid system overlaps.
                                  child: SafeArea(
                                    top: false,
                                    child: CupertinoPicker(
                                      itemExtent: 32.0, 
                                      onSelectedItemChanged: (int selectedType) async {
                                        
                                        switch (transporationType[selectedType]) {
                                          case "Drive":
                                            if (map != null) {
                                              var googleRoute = await getRoute.getRoute(mapRes!.mapValue["user"]!.$1, mapRes!.mapValue["dest"]!.$1, "DRIVE");
                                              
                                              

                                              setState(() {
                                                selectedTypeTrans = "Drive";
                                                if (googleRoute.$1.isEmpty) {
                                                  mapRes!.polyline = null;
                                                }  else {
                                                  mapRes!.polyline = Polyline(
                                                    polylineId: PolylineId("polyRoutes"), 
                                                    color: CupertinoColors.activeBlue, 
                                                    points: googleRoute.$1,
                                                  );
                                                }
                                                
                                                generateMap();
                                              });

                                            }
                                            break;
                                          case "Bicylce":
                                            if (map != null) {
                                              var googleRoute = await getRoute.getRoute(mapRes!.mapValue["user"]!.$1, mapRes!.mapValue["dest"]!.$1, "BICYCLE");
                                              
                                              
                                              setState(() {
                                                selectedTypeTrans = "Bicylce";

                                                if (googleRoute.$1.isEmpty) {
                                                  mapRes!.polyline = null;
                                                }  else {
                                                  mapRes!.polyline = Polyline(
                                                    polylineId: PolylineId("polyRoutes"), 
                                                    color: CupertinoColors.activeBlue, 
                                                    points: googleRoute.$1,
                                                  );
                                                }
                                                
                                                

                                                generateMap();
                                              });

                                            }
                                            break;
                                          case "Walk":
                                            if (map != null) {
                                              var googleRoute = await getRoute.getRoute(mapRes!.mapValue["user"]!.$1, mapRes!.mapValue["dest"]!.$1, "WALK");
                                              
                                              setState(() {
                                                selectedTypeTrans = "Walk";

                                                if (googleRoute.$1.isEmpty) {
                                                  mapRes!.polyline = null;
                                                }  else {
                                                  mapRes!.polyline = Polyline(
                                                    polylineId: PolylineId("polyRoutes"), 
                                                    color: CupertinoColors.activeBlue, 
                                                    points: googleRoute.$1,
                                                  );
                                                }

                                                generateMap();
                                              });

                                            }
                                            break;
                                          case "Motor Cycle":
                                            if (map != null) {
                                              var googleRoute = await getRoute.getRoute(mapRes!.mapValue["user"]!.$1, mapRes!.mapValue["dest"]!.$1, "TWO_WHEELER");
                                              
                                              setState(() {
                                                selectedTypeTrans = "Motor Cycle";

                                                if (googleRoute.$1.isEmpty) {
                                                  mapRes!.polyline = null;
                                                }  else {
                                                  mapRes!.polyline = Polyline(
                                                    polylineId: PolylineId("polyRoutes"), 
                                                    color: CupertinoColors.activeBlue, 
                                                    points: googleRoute.$1,
                                                  );
                                                }

                                                generateMap();
                                              });
                                            }
                                            break;
                                        }

                                        
                                      },
                                      scrollController: FixedExtentScrollController(
                                        initialItem: transporationType.indexOf(selectedTypeTrans),
                                      ),
                                      children: List<Widget>.generate(
                                        transporationType.length, 
                                        (index) => Center(child: Text(transporationType[index])))
                                      ),
                                  ),
                                ),
                              );
                            }
                          ),
                        // ),
                      ],
                    ),
                    // Expanded(
                      // child: (map != null) ? map! : SizedBox.shrink(),
                    // )
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
