
import 'package:replicanano2_malarm/core/entities/records.dart';
import 'package:replicanano2_malarm/core/services/persistent_storage.dart';
import 'package:sqflite/sqflite.dart';

class DeleteRecordUseCase {
  PersistentStorage db = PersistentStorage();
  late Database database;

  Future<int>delete(CustRecord rec) async {
    var rowEffected = await database.delete("record", where: "id = ?", whereArgs: [rec.id]);
    
    return rowEffected;
  }
}