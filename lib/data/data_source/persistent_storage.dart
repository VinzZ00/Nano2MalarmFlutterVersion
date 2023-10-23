import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../core/entities/records.dart';

class PersistentStorage {
  Database? _database;

  PersistentStorage._();
   
  static final PersistentStorage shared = PersistentStorage._();

  Future<Database> get database async 
  {
    if (_database != null) {
     return _database!;
    }

    _database = await _initDatabase();
    return _database!;
    
  }

  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), 'my_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreateFunc,
    );
  }

  Future<void> _onCreateFunc(Database db, int version) async {
    await db.execute('''

      CREATE TABLE record (
        id Integer PRIMARY KEY,
        latitude DOUBLE,
        longitude DOUBLE, 
        description String,
        date String,
        complete Integer,
      )

    ''');
  }

  Future<void> insertRow(Database db, CustRecord rec) async {
    await db.insert('record', rec.toMap());
  }

  Future<List<Map>> getRow(Database db) async {
    var records = await db.query(
      'record',
      columns: ['id', 'latitude', 'longitude', 'description', 'date'],
    );

    return records;
  }
}