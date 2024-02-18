import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart'; //import these
import 'package:mob_pit/nmodel.dart';
import 'nmodel.dart';

class DBHElper {
  //this is to initialize the SQLite database
  //Database is from sqflite package
  //as well as getDatabasesPath()
  static Future<Database> initDB() async {
    var dbPath = await getDatabasesPath();
    String path = join(dbPath, 'notes.db');
    //this is to create database
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  //build _onCreate function
  static Future _onCreate(Database db, int version) async {

    final sql = '''CREATE TABLE note(
      id INTEGER PRIMARY KEY,
      title TEXT,
      subject TEXT,
      date TEXT,
      description TEXT
    )''';
    //sqflite is only support num, string, and unit8List format
    //please refer to package doc for more details
    await db.execute(sql);
  }

  //build create function (insert)
  static Future<int> createNote(Note note) async {
    Database db = await DBHElper.initDB();
    //create contact using insert()
    return await db.insert('note', note.toJson());
  }

  //build read function
  static Future<List<Note>> readNote() async {
    Database db = await DBHElper.initDB();
    var contact = await db.query('note', orderBy: 'id');
    //this is to list out the contact list from database
    //if empty, then return empty []
    List<Note> noteList = contact.isNotEmpty
        ? contact.map((details) => Note.fromJson(details)).toList()
        : [];
    return noteList;
  }

  //build update function
  static Future<int> updateNote(Note note) async {
    Database db = await DBHElper.initDB();
    //update the existing contact
    //according to its id
    return await db.update('note', note.toJson(),
        where: 'id = ?', whereArgs: [note.id]);
  }

  //build delete function
  static Future<int> deleteNote(int id) async {
    Database db = await DBHElper.initDB();
    //delete existing contact
    //according to its id
    return await db.delete('note', where: 'id = ?', whereArgs: [id]);
  }
}