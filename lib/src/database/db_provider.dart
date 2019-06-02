import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../models/note.dart';
import 'package:todo_list/src/models/label.dart';
import 'package:todo_list/src/models/note_label.dart';
import 'package:todo_list/src/models/image.dart';

class AppDatabase {
  static const String DATABASE_NAME = 'todo_list';

  AppDatabase._() {
    Sqflite.setDebugModeOn(true);
  }

  static final AppDatabase appDatabase = AppDatabase._();

  static Database _database;

  Future<Database> get database async {
    if (_database == null) {
      _database = await initDatabase();
    }
    return _database;
  }

  Future<Database> initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, DATABASE_NAME);
    return await openDatabase(path, version: 1, onOpen: (db) {
      print('Database path: ${db.path}');
    }, onCreate: (Database db, int version) async {
      await createNoteTable(db);
      await createLabelTable(db);
      await createNoteLabelTable(db);
    }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
      await db.execute("DROP TABLE IF EXISTS ${Note.TABLE_NAME}");
      await db.execute("DROP TABLE IF EXISTS ${Label.TABLE_NAME}");
      await db.execute("DROP TABLE IF EXISTS ${NoteLabel.TABLE_NAME}");
      await db.execute("DROP TABLE IF EXISTS ${Image.TABLE_NAME}");

      await createNoteTable(db);
      await createLabelTable(db);
      await createNoteLabelTable(db);
    });
  }

  createNoteTable(Database db) async {
    await db.execute("CREATE TABLE ${Note.TABLE_NAME} ("
        "${Note.DB_ID} INTEGER PRIMARY KEY AUTOINCREMENT,"
        "${Note.DB_TITLE} TEXT,"
        "${Note.DB_CONTENT} TEXT,"
        "${Note.DB_COLOR} INTEGER,"
        "${Note.DB_IMAGE} TEXT,"
        "${Note.DB_CREATED_AT} LONG,"
        "${Note.DB_DONE} INTEGER"
        ")");
  }

  createLabelTable(Database db) async {
    return db.transaction((Transaction txn) async {
      txn.execute("CREATE TABLE ${Label.TABLE_NAME} ("
          "${Label.DB_ID} INTEGER PRIMARY KEY AUTOINCREMENT,"
          "${Label.DB_NAME} TEXT,"
          "${Label.DB_CREATED_AT} LONG"
          ")");

      txn.insert(Label.TABLE_NAME, Label.create('Todo List').toMap());
    });
  }

  createNoteLabelTable(Database db) async {
    await db.execute("CREATE TABLE ${NoteLabel.TABLE_NAME} ("
        "${NoteLabel.DB_ID} INTEGER PRIMARY KEY AUTOINCREMENT,"
        "${NoteLabel.DB_NOTE_ID} INTEGER,"
        "${NoteLabel.DB_LABEL_ID} INTEGER,"
        "FOREIGN KEY (${NoteLabel.DB_NOTE_ID}) REFERENCES ${Note.TABLE_NAME}(${Note.DB_ID}) ON DELETE CASCADE,"
        "FOREIGN KEY (${NoteLabel.DB_LABEL_ID}) REFERENCES ${Label.TABLE_NAME}(${Label.DB_ID}) ON DELETE CASCADE"
        ")");
  }
}
