import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:test_interview/data/db_helper/home/model/notes.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static Database? _database;

  // Table and column names
  final String noteTable = 'note_table';
  final String colId = 'id';
  final String colTitle = 'title';
  final String colDescription = 'description';
  final String colStatus = 'status';
  final String colDate = 'date';
  final String colCreatedAt = 'createdAt';
  final String colUpdatedAt = 'updatedAt';
  final String colPriority = 'priority';
  final String colColor = 'color';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    _databaseHelper ??= DatabaseHelper._createInstance();
    return _databaseHelper!;
  }

  Future<Database> get database async {
    _database ??= await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      String path = '${directory.path}/notes.db';

      var notesDatabase = await openDatabase(
        path,
        version: 2,
        onCreate: _createDb,
        onUpgrade: _upgradeDb,
      );
      return notesDatabase;
    } catch (e) {
      throw Exception('Error initializing database: $e');
    }
  }

  Future<void> _createDb(Database db, int newVersion) async {
    try {
      await db.execute('''
        CREATE TABLE $noteTable (
          $colId INTEGER PRIMARY KEY AUTOINCREMENT,
          $colTitle TEXT NOT NULL,
          $colDescription TEXT,
          $colStatus INTEGER NOT NULL DEFAULT 0,
          $colDate TEXT NOT NULL,
          $colCreatedAt TEXT NOT NULL,
          $colUpdatedAt TEXT,
          $colPriority INTEGER NOT NULL,
          $colColor INTEGER NOT NULL
        )
      ''');
    } catch (e) {
      throw Exception('Error creating table: $e');
    }
  }

  Future<void> _upgradeDb(Database db, int oldVersion, int newVersion) async {
    try {
      if (oldVersion < 2) {
        // Thêm cột status vào bảng hiện có
        await db.execute(
            'ALTER TABLE $noteTable ADD COLUMN $colStatus INTEGER DEFAULT 0');
      }
    } catch (e) {
      throw Exception('Error upgrading database: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    try {
      Database db = await database;
      return await db.query(
        noteTable,
        orderBy: '$colPriority ASC',
      );
    } catch (e) {
      throw Exception('Error fetching notes: $e');
    }
  }

  Future<int> insertNote(Note note) async {
    try {
      Database db = await database;
      return await db.insert(noteTable, note.toMap());
    } catch (e) {
      throw Exception('Error inserting note: $e');
    }
  }

  Future<int> updateNote(Note note) async {
    try {
      if (note.id == null) {
        throw Exception('Note ID cannot be null for update');
      }
      Database db = await database;
      return await db.update(
        noteTable,
        note.toMap(),
        where: '$colId = ?',
        whereArgs: [note.id],
      );
    } catch (e) {
      throw Exception('Error updating note: $e');
    }
  }

  Future<int> deleteNote(int id) async {
    try {
      Database db = await database;
      return await db.delete(
        noteTable,
        where: '$colId = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception('Error deleting note: $e');
    }
  }

  Future<int> getCount() async {
    try {
      Database db = await database;
      final result = await db.rawQuery('SELECT COUNT(*) from $noteTable');
      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      throw Exception('Error getting note count: $e');
    }
  }

  Future<List<Note>> getNoteList() async {
    try {
      final noteMapList = await getNoteMapList();
      return noteMapList.map((map) => Note.fromMapObject(map)).toList();
    } catch (e) {
      throw Exception('Error converting to note list: $e');
    }
  }
}
