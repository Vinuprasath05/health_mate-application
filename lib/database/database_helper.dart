
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDB('healthmate.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
  
    
    final path = join(dbPath, fileName);

      print("Database Path: $path");

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE health_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        steps INTEGER NOT NULL,
        calories REAL NOT NULL,
        water REAL NOT NULL
      )
    ''');
  }

  // INSERT - Add health record
  Future<int> insertRecord(Map<String, dynamic> record) async {
    final db = await instance.database;

    return await db.insert(
      'health_records',
      record,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // READ - Get all health records
  Future<List<Map<String, dynamic>>> getAllRecords() async {
    final db = await instance.database;

    return await db.query(
      'health_records',
      orderBy: 'date DESC',
    );
  }

  // READ - Get record by ID
  Future<Map<String, dynamic>?> getRecordById(int id) async {
    final db = await instance.database;

    final result = await db.query(
      'health_records',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return result.first;
    }

    return null;
  }

  // UPDATE - Edit health record
  Future<int> updateRecord(
    int id,
    Map<String, dynamic> record,
  ) async {
    final db = await instance.database;

    return await db.update(
      'health_records',
      record,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // DELETE - Delete health record
  Future<int> deleteRecord(int id) async {
    final db = await instance.database;

    return await db.delete(
      'health_records',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // SEARCH - Search records by date
  Future<List<Map<String, dynamic>>> searchByDate(
    String date,
  ) async {
    final db = await instance.database;

    return await db.query(
      'health_records',
      where: 'date = ?',
      whereArgs: [date],
    );
  }

  // CLOSE DATABASE
  Future<void> closeDatabase() async {
    final db = await instance.database;
    await db.close();
    _database = null;
  }

  Future<Map<String, dynamic>?> getRecordByDate(
  String date,
) async {
  final db = await instance.database;

  final result = await db.query(
    'health_records',
    where: 'date = ?',
    whereArgs: [date],
    limit: 1,
  );

  return result.isNotEmpty ? result.first : null;
}
}
