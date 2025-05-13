import 'dart:io';

import 'package:maps_app/models/address_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

// Handles local SQLite database operations for storing addresses.
class AddressesDatabase {
  Database? _db;

  // Lazy-loads and returns the database instance.
  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  // Initializes the database and creates the addresses table if not exists.
  Future<Database> _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory(); // App's document directory.
    String path = join(dir.path, 'db/addresses_db.dart'); // Path to database file.

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // SQL to create address table with multiple fields.
        await db.execute('''
          CREATE TABLE addresses (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            thoroughfare TEXT,
            street TEXT,
            locality TEXT,
            subAdministrativeArea TEXT,
            administrativeArea TEXT,
            country TEXT,
            postalCode TEXT,
            isoCountryCode TEXT
          )
        ''');
      },
    );
  }

  // Inserts a new address into the database.
  Future<void> insertAddress(AddressModel address) async {
    final db = await database;
    await db.insert('addresses', address.toMap());
  }

  // Retrieves all stored addresses from the database.
  Future<List<AddressModel>> getAddresses() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('addresses');
    return maps.map((map) => AddressModel.fromMap(map)).toList();
  }

  // Updates an existing address by its ID.
  Future<void> updateAddress(AddressModel address) async {
    final db = await database;
    await db.update(
      'addresses',
      address.toMap(),
      where: 'id = ?',
      whereArgs: [address.id],
    );
  }

  // Deletes an address from the database by its ID.
  Future<void> deleteAddress(int id) async {
    final db = await database;
    await db.delete(
      'addresses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
