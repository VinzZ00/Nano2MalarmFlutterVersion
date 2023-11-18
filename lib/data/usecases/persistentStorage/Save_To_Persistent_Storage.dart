
import 'package:replicanano2_malarm/core/entities/records.dart';
import 'package:replicanano2_malarm/core/services/persistent_storage.dart';
import 'package:sqflite/sqflite.dart';

class SaveToPersistentStorageUseCase {
  PersistentStorage db = PersistentStorage();
  late Database database;
  
  SaveToPersistentStorageUseCase() {
    initDatabase();
  }

  void initDatabase() async {
    database =  await db.database;
  }

  Future<int>save(CustRecord rec) async  {
    var rowId = await database.insert("record", rec.toMap(), conflictAlgorithm: ConflictAlgorithm.fail);

    if (rowId != -1) {
      return rowId;
    } else {
      throw Exception("Elvin-97 Error in inserting data from Future<int>save(CustRecord rec) async");
    }

  }

  


}