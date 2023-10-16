import 'package:flutter/material.dart';
import 'package:replicanano2_malarm/presenters/components/todo_list_record.dart';
import 'package:replicanano2_malarm/data/entities/records.dart';
import 'package:uuid/uuid.dart';
import 'package:replicanano2_malarm/core/services/persistent_storage.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  State<HomeWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<HomeWidget> {
  PersistentStorage persistentStorage = PersistentStorage();
  
  var dbPromise = PersistentStorage().database;

  List<CustRecord> toDoListRecord = [];

  var rec = CustRecord('', 0.0, 0.0, '', DateTime.now(), false);

  String id = const Uuid().toString();
  double latitude = 0.0, longitude = 0.0;
  String description = "";

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Todo List", 
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            color: Colors.black,
            onPressed: () {}),
        ],
        elevation: 0.0,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: createRowData(),
      ),
    );
  }

  List<Widget> createRowData() {
    List<Widget> rows = [];

    for (var rec in toDoListRecord) {
      rows.add(RecordOfToDoList(rec: rec));
    }

    return rows;
  }

  @override
  void initState() {
    super.initState();    
    getRecordUseCase();

  }

  void getRecordUseCase() async {

    toDoListRecord = [];

    var db = await dbPromise;
    var results = persistentStorage.getRow(db);
    var res = await results;

    for (var record in res) {
      rec.fromMap(record);
      toDoListRecord.add(rec);
    }
  }
}

