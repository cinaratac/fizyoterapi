// lib/services/database_helper.dart (TAM VE DÜZELTİLMİŞ)

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Kotlin'deki private val'lerin Dart'taki karşılığı
const _databaseName = "DATA_FİZYO";
const _tableHasta = 'HASTALAR';
const _tableDoktor = 'DOKTORLAR';
const _columnPhone = 'phone';
const _columnPassword = 'password';
const _columnSure = 'ekran_süresi';
const _columnId = 'id';

class DatabaseHelper {
  
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Veritabanı dosya yolu
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // onCreate: Tabloları oluşturma
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $_tableHasta(
            $_columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $_columnPhone TEXT NOT NULL, 
            $_columnSure TEXT,
            $_columnPassword TEXT NOT NULL
          )
          ''');
    await db.execute('''
          CREATE TABLE $_tableDoktor(
            $_columnPhone TEXT NOT NULL, 
            $_columnPassword TEXT NOT NULL
          )
          ''');
  }
  
  // 1. insertHasta: Hasta kaydı ekler.
  Future<void> insertHasta(String phone, String password) async {
    final db = await instance.database;
    await db.insert(_tableHasta, {_columnPhone: phone, _columnPassword: password});
  }

  // 2. insertDoktor: Doktor kaydı ekler.
  Future<void> insertDoktor(String phone, String password) async {
    final db = await instance.database;
    await db.insert(_tableDoktor, {_columnPhone: phone, _columnPassword: password});
  }

  // 3. checkHasta: Hasta girişini kontrol eder.
  Future<bool> checkHasta(String phone, String password) async {
    final db = await instance.database;
    List<Map> result = await db.query(
      _tableHasta,
      where: '$_columnPhone = ? AND $_columnPassword = ?',
      whereArgs: [phone, password],
    );
    return result.isNotEmpty;
  }

  // 4. checkDoktor: Doktor girişini kontrol eder.
  Future<bool> checkDoktor(String phone, String password) async {
    final db = await instance.database;
    List<Map> result = await db.query(
      _tableDoktor,
      where: '$_columnPhone = ? AND $_columnPassword = ?',
      whereArgs: [phone, password],
    );
    return result.isNotEmpty;
  }

  // 5. getAllHastaPhones: Tüm hasta telefon numaralarını çeker.
  Future<List<String>> getAllHastaPhones() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(_tableHasta, columns: [_columnPhone]);
    
    // Sadece telefon numaralarını içeren bir liste döndürür
    return List.generate(maps.length, (i) {
      return maps[i][_columnPhone] as String;
    });
  }
}