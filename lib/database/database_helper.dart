import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  DatabaseHelper._init();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('money_manager.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();

    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE transactions(

id INTEGER PRIMARY KEY AUTOINCREMENT,

title TEXT NOT NULL,

amount REAL NOT NULL,

type TEXT NOT NULL,

category TEXT NOT NULL,

note TEXT,

date TEXT,

receipt TEXT,

created_at TEXT

)
''');
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }

  Future<int> insertTransaction(Map<String, dynamic> data) async {
  final db = await instance.database;

  return await db.insert(
    'transactions',
    data,
  );
}

Future<List<Map<String, dynamic>>> getTransactions() async {
  final db = await instance.database;

  return await db.query(
    'transactions',
    orderBy: 'id DESC',
  );
}

Future<int> updateTransaction(
    int id,
    Map<String, dynamic> data,
    ) async {
  final db = await instance.database;

  return await db.update(
    'transactions',
    data,
    where: 'id=?',
    whereArgs: [id],
  );
}

Future<int> deleteTransaction(int id) async {
  final db = await instance.database;

  return await db.delete(
    'transactions',
    where: 'id=?',
    whereArgs: [id],
  );
}
}