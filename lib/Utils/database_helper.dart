// ignore_for_file: unnecessary_this, prefer_interpolation_to_compose_strings

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:note_take/Models/model.dart';
import 'dart:async';
import 'dart:io';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper; // singleton (only once in a class)
  static Database? _database;

  String noteTable = "note_table";
  String colDescription = "description";
  String colTitle = "title";
  String colDate = "date";
  String colPriority = "priority";
  String colId = "id";

  DatabaseHelper._createInstance(); //Named constructor to create instance of DatabaseHelper
  factory DatabaseHelper() {
    _databaseHelper = DatabaseHelper._createInstance();
    return _databaseHelper!;
  }

  Future<Database> get database async {
    _database = await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    // Get directory path to store database
    Directory directory =
        await getApplicationDocumentsDirectory(); // Belongs to path_provider package
    String path = directory.path + 'note.db';

    // Create(open) database at this given path
    var notedDatabase =
        await openDatabase(path, version: 1, onCreate: _createDB);
    return notedDatabase;
  }

  void _createDB(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colDescription TEXT, $colPriority INTEGER, $colDate TEXT)');
  }

  // To fetch all notes object from database

  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;

    var result = await db.rawQuery(
        'SELECT * FROM $noteTable order by $colPriority ASC'); // Using raw query

    // var result = await db.query(noteTable, orderBy: '$colPriority ASC');   // Using helper function
    return result;
  }

  Future<int> insertNode(Model note) async {
    Database db = await this.database;
    var result = await db.insert(noteTable, note.toMap());
    return result;
  }

  Future<int> updateNote(Model note) async {
    Database db = await this.database;
    var result = await db.update(noteTable, note.toMap(),
        where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }

  Future<int> deleteNote(int id) async {
    Database db = await this.database;
    var result =
        await db.rawDelete('DELETE FROM $noteTable WHERE $colId = $id');
    return result;
  }

  Future<int?> getCount() async {
    Database db = await this.database;

    List<Map<String, dynamic>> x;
    x = await db.rawQuery('SELECT COUNT * from $noteTable');
    int? result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Model>> getNoteList() async {
    var noteMapList = await getNoteMapList();
    int count = noteMapList.length;

    List<Model> noteList = <Model>[];
    for (int i = 0; i < count; i++) {
      noteList.add(Model.fromMapObject(noteMapList[i]));
    }
    return noteList;
  }
}
