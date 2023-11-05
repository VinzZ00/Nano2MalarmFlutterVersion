import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:replicanano2_malarm/core/entities/records.dart';

class RecordOfToDoList extends StatelessWidget {
  
  RecordOfToDoList({
    super.key,
    required this.rec
    });
  final CustRecord rec;

  final DateFormat dateFormatter = DateFormat('EEEE, dd MMMM yyyy');
  final DateFormat timeFormatter = DateFormat('HH.mm');
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 16
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(dateFormatter.format(rec.date)),
                Text(
                  rec.complete == true ? "Complete" : "Incomplete",
                  style : TextStyle(
                    color : rec.complete == true ? Colors.green[400] : Colors.red[400]
                  )
                  ),
              ],
            ),
      
            const SizedBox(height: 20),
      
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    timeFormatter.format(rec.date),
                    style: TextStyle(fontSize: 70),
                    ),
                  Text(rec.description.length > 7 ? "${rec.description.substring(0,7)}..." : rec.description),
                ],
              ),
            ),
            Divider(
              height: 10,
              thickness: 2,
              color: Colors.grey[400]
            )
          ], 
        ),
      ),
    );
  }
}