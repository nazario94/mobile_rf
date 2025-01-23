import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('drive_test_data.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE rf_data (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        latitude DOUBLE,
        longitude DOUBLE,
        rssi INTEGER,
        cell_id TEXT,
        timestamp TEXT
      )
    ''');
  }

  Future<int> insertData(Map<String, dynamic> data) async {
    final db = await instance.database;
    return await db.insert('rf_data', data);
  }
}
