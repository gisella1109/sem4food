import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _db;

  Future<Database> get database async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'food_log.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE glucose (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nilai REAL NOT NULL,
        waktu TEXT NOT NULL,
        konteks_makan TEXT NOT NULL,
        catatan TEXT DEFAULT ""
      )
    ''');

    await db.execute('''
      CREATE TABLE medication (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama_obat TEXT NOT NULL,
        dosis TEXT NOT NULL,
        frekuensi TEXT NOT NULL,
        waktu_konsumsi TEXT NOT NULL,
        tipe TEXT NOT NULL,
        catatan TEXT DEFAULT "",
        dibuat_pada TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE user (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        dibuat_pada TEXT NOT NULL
      )
    ''');
  }

  // ── GLUCOSE ───────────────────────────────────────────────────────────────
  Future<int> insertGlucose(Map<String, dynamic> data) async {
    final db = await database;
    return db.insert('glucose', data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getAllGlucose() async {
    final db = await database;
    return db.query('glucose', orderBy: 'waktu DESC');
  }

  Future<int> deleteGlucose(int id) async {
    final db = await database;
    return db.delete('glucose', where: 'id = ?', whereArgs: [id]);
  }

  // ── MEDICATION ────────────────────────────────────────────────────────────
  Future<int> insertMedication(Map<String, dynamic> data) async {
    final db = await database;
    return db.insert('medication', data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getAllMedication() async {
    final db = await database;
    return db.query('medication', orderBy: 'dibuat_pada DESC');
  }

  Future<int> deleteMedication(int id) async {
    final db = await database;
    return db.delete('medication', where: 'id = ?', whereArgs: [id]);
  }

  // ── USER ──────────────────────────────────────────────────────────────────
  Future<int> insertUser(Map<String, dynamic> data) async {
    final db = await database;
    return db.insert('user', data,
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await database;
    final result = await db.query('user',
        where: 'email = ?', whereArgs: [email], limit: 1);
    return result.isNotEmpty ? result.first : null;
  }
}