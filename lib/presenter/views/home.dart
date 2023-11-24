// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';

import 'package:replicanano2_malarm/presenter/views/components/todo_list_record.dart';
import 'package:replicanano2_malarm/core/entities/records.dart';
import 'package:replicanano2_malarm/presenter/views/form.dart';

import 'package:uuid/uuid.dart';
import 'package:replicanano2_malarm/core/services/persistent_storage.dart';

class HomeWidget extends StatefulWidget {

  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<HomeWidget> {
  // final mapKeyWidgetKey = GlobalKey<MapPageState>(debugLabel: "MapGlobalKey");
  void _showActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      
      context: context,
      builder: (BuildContext context) => Dismissible(
        key: ValueKey("Dismissable_modal"), 
        direction: DismissDirection.down,
        onDismissed: (_) {
          Navigator.pop(context);
        }, 
        child: FormPage(key: ValueKey("FormPage"))
      )
    );
  }
  
  PersistentStorage persistentStorage = PersistentStorage();
  BuildContext? _scafoldContext;
  var dbPromise = PersistentStorage().database;

  List<CustRecord> toDoListRecord = [];

  

  String id = const Uuid().toString();
  double latitude = 0.0, longitude = 0.0;
  String description = "";
  

  @override
  Widget build(BuildContext context) {

    _scafoldContext = context;  
    return CupertinoPageScaffold(
      navigationBar : CupertinoNavigationBar(
        middle: Text("Todo List"),
        trailing : GestureDetector(
          child: Icon(CupertinoIcons.add, color: CupertinoColors.activeBlue),
          onTap: () {
            if (this._scafoldContext != null) {
              _showActionSheet(_scafoldContext!);
            }
          },
        ),
      ),
      child: Builder(
        builder: (context) {
          _scafoldContext  = context;
          return ListView(
            children: createRowData(),
          );
        }
      )
    );
  }

  List<Widget> createRowData() {
    List<Widget> rows = [];

    

    for (var rec in toDoListRecord) {
      print("Record of Home 2: ${rec.toMap()}");
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
    List<CustRecord> fetchedRecord = [];

    var db = await dbPromise;
    var results = persistentStorage.getRow(db);
    var res = await results;



    for (var record in res) {
      print("Record of Home : ${record}");
      
      var rec = CustRecord.init().fromMap(record);

      print("rec adalah : ${rec.toMap()}");
      


      fetchedRecord.add(rec);

      fetchedRecord.forEach((e) { print("e Title : ${e.title}"); });
    }
    setState(() {
        toDoListRecord = [];

        fetchedRecord.forEach((e) { print("c Title : ${e.title}"); });

        toDoListRecord = fetchedRecord;
    });

    toDoListRecord.forEach((b) { print("b Title : ${b.title}"); });
  }
}

