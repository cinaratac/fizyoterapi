// lib/services/database_helper.dart (DÜZELTİLMİŞ VE KESİN ÇÖZÜM)

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = "DATA_FİZYO";
  static const _databaseVersion = 1;

  static const tableHasta = 'HASTALAR';
  static const tableDoktor = 'DOKTORLAR';

  static const columnPhone = 'phone';
  static const columnPassword = 'password';
  static const columnSure = 'ekran_süresi';
  static const columnId = 'id';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $tableHasta (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnPhone TEXT NOT NULL,
            $columnSure TEXT,
            $columnPassword TEXT NOT NULL
          )
          ''');
    await db.execute('''
          CREATE TABLE $tableDoktor (
            $columnPhone TEXT NOT NULL,
            $columnPassword TEXT NOT NULL
          )
          ''');
  }

  Future<int> insertHasta(String phone, String password) async {
    final db = await instance.database; // db tanımlı
    return await db.insert(tableHasta, {columnPhone: phone, columnPassword: password});
  }

  Future<bool> checkHasta(String phone, String password) async {
    final db = await instance.database; // db tanımlı
    List<Map> result = await db.query(
      tableHasta,
      columns: [columnPhone],
      where: '$columnPhone = ? AND $columnPassword = ?',
      whereArgs: [phone, password],
    );
    return result.isNotEmpty;
  }
  
  Future<int> insertDoktor(String phone, String password) async {
    final db = await instance.database; // db tanımlı
    return await db.insert(tableDoktor, {columnPhone: phone, columnPassword: password});
  }

  Future<bool> checkDoktor(String phone, String password) async {
    final db = await instance.database; // db tanımlı
    List<Map> result = await db.query(
      tableDoktor,
      columns: [columnPhone],
      where: '$columnPhone = ? AND $columnPassword = ?',
      whereArgs: [phone, password],
    );
    return result.isNotEmpty;
  }
  
  // ⭐️ HATA DÜZELTİLDİ: 'db' değişkeni tanımlandı
  Future<List<String>> getAllHastaPhones() async {
    final db = await instance.database; // Eksik olan satır eklendi.
    final List<Map<String, dynamic>> maps = await db.query(tableHasta, columns: [columnPhone]);
    
    return List.generate(maps.length, (i) {
      return maps[i][columnPhone] as String;
    });
  }
}