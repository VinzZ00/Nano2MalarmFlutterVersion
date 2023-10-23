// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';



class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {

  DateTime selectedDate = DateTime(2023, 10, 18, 16, 36);

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

    var eventNameTextController = TextEditingController(text: "");

    return CupertinoPageScaffold(
      child: SafeArea(
        child: Column(
          children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: CupertinoTextField(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  controller: eventNameTextController,
                  placeholder: "Event"
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
                              style: const TextStyle(
                                fontSize: 20.0,
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
                onPressed: () {},
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: CupertinoColors.systemGrey
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                            child: Icon(CupertinoIcons.location_solid),
                          ),
                          Text("Point on map on where you wanna go"),
                          ],
                        ),
                  ),
                )
              ),
              // TextButton.icon(
              //   onPressed: () {
                  
              //   },
              //   icon: Icon(Icons.place),
              //   label: Text("Point on map on where you wanna go")
              // )
          ],
        ),
      ),
    );
  }
}
