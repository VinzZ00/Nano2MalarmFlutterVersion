// ignore_for_file: prefer_const_constructors


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/entities/places.dart';
// import 'package:flutter/material.dart';



class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {

  Marker? userLoc;
  Marker? destLoc;
  String? destName;
  DateTime selectedDate = DateTime(2023, 10, 18, 16, 36);
  var eventNameTextController = TextEditingController(text: "");
  var descriptionTextController = TextEditingController(text: "");

  void _showDialog(Widget child) {
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
          child: child,
        ),
      ),
    );
  }

  

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
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
                                ),
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
                        
                    Set<(String, Map<String, (Place, Marker)>)> results = <(String, Map<String, (Place, Marker)>)>{("String", {
                      "String" : (Place(name: "", latNlong: LatLng(0, 0), placeId: ""), Marker(markerId: MarkerId("value"))),
                    })};
      
                    var result = await Navigator.pushNamed(context, "/form/map");
      
                    if (result is Set<(String, Map<String, (Place, Marker)>)>) {
                      destName = result.last.$1;
                      if (result.last.$2['user'] != null) {
                        userLoc = result.last.$2['user']!.$2;
                      }
                      
                      if (result.last.$2['dest'] != null) {
                        destLoc = result.last.$2['dest']?.$2;
                      }
                    }
      
                    // if (result is Map<String, Map<String, (Marker, Place)>>) {
                    //   destName = result.keys.first;
                    //   userLoc = result[destName]?["user"]?.$1;
                    //   destLoc = result[destName]?["dest"]?.$1;
                    // }
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
                                (destName != null) ? destName! : 
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
                )
                
            ],
          ),
        ),
      ),
    );
  }
}
