import 'dart:io';

import 'package:flutter/services.dart';
import 'package:new_not_sepeti/models/kategori.dart';
import 'package:new_not_sepeti/models/not.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static Database? _database;

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._internal();
      return _databaseHelper!;
    } else {
      return _databaseHelper!;
    }
  }
  DatabaseHelper._internal();

  Future<Database> _getDatabase() async {
    if (_database == null) {
      _database = await _initializeDatabase();
      return _database!;
    } else {
      return _database!;
    }
  }

  Future<Database> _initializeDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "notlar.db");

// Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", "notlar.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }
// open the database
    return await openDatabase(path, readOnly: false);
  }

  //////////////KATEGORİ İŞLEMLERİ /////////////////
  Future<List<Kategori>> kategorilerinListesiniGetir() async {
    var kategorileriIcerenMapListesi = await kategorileriGetir();
    var kategoriListesi = <Kategori>[];

    for (Map<String, dynamic> map in kategorileriIcerenMapListesi) {
      kategoriListesi.add(Kategori.fromMap(map));
    }
    return kategoriListesi;
  }

  Future<List<Map<String, Object?>>> kategorileriGetir() async {
    var db = await _getDatabase();
    var sonuc = await db.query('kategori');
    return sonuc;
  }

  Future<int> kategoriEkle(Kategori kategori) async {
    var db = await _getDatabase();
    var sonuc = await db.insert('kategori', kategori.toMap());
    return sonuc;
  }

  Future<int> kategoriSil(int kategoriID) async {
    var db = await _getDatabase();
    var sonuc = await db
        .delete('kategori', where: 'kategoriID = ?', whereArgs: [kategoriID]);
    return sonuc;
  }

  Future<int> kategoriGuncelle(Kategori kategori) async {
    var db = await _getDatabase();
    var sonuc = await db.update('kategori', kategori.toMap(),
        where: 'kategoriID = ?', whereArgs: [kategori.kategoriID]);
    return sonuc;
  }

  ////////////NOT İŞLEMLERİ /////////////////
  Future<List<Not>> notListesiniGetir() async {
    var notlariIcerenMapLisetsi = await notGetir();
    var notListesi = <Not>[];

    for (Map<String, dynamic> map in notlariIcerenMapLisetsi) {
      notListesi.add(Not.fromMap(map));
    }
    return notListesi;
  }

  Future<List<Map<String, dynamic>>> notGetir() async {
    var db = await _getDatabase();
    var sonuc = await db.query('notlar');
    return sonuc;
  }

  Future<int> notEkle(Not not) async {
    var db = await _getDatabase();
    var sonuc = db.insert('notlar', not.toMap());
    return sonuc;
  }

  Future<int> notSil(int notID) async {
    var db = await _getDatabase();
    var sonuc =
        await db.delete('notlar', where: 'notID = ?', whereArgs: [notID]);
    return sonuc;
  }

  Future<int> notGuncelle(Not not) async {
    var db = await _getDatabase();
    var sonuc = await db.update('notlar', not.toMap(),
        where: 'notID = ?', whereArgs: [not.notID]);
    return sonuc;
  }
}
