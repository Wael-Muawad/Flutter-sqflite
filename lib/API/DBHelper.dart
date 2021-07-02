import 'package:flutter/material.dart';
import 'package:second/Model/Student.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {


  // create singleton object from DBHelper (must be static)
  static DBHelper _helper;

  // reference to do operation of DB
  Database _database;

  DBHelper._getInstance(); // create private constructor
  factory DBHelper() {
    if (_helper == null)
      _helper = DBHelper._getInstance();
    return _helper;
  }

  // 1. Open Database and create table
  String dbName = 'university.db';
  String tableName = 'student';
  String dbCreateTable =
      'CREATE TABLE student(id INTEGER PRIMARY KEY, name TEXT, major TEXT, mark INTEGER)';

  initializeDB() async {
    // to avoid conflict in case of multiple versions
    WidgetsFlutterBinding.ensureInitialized();

    //create a new DB if not already created or use it if exist
    //must be final because once it has value it could never change
    final Future <Database> database = openDatabase(
      join(await getDatabasesPath(), dbName,), // path
      version: 1,
      onCreate: (db, version) => db.execute(dbCreateTable),
    );

    _database = await database;
  }


  // 2. Create functions for query
  Future <void> insertStudent(Student s) async {
    if (_database == null)
      await initializeDB();

    await _database.insert(tableName, s.objectToMap());
  }

  updateStudent(Student s) async {
    if (_database == null)
      await initializeDB();

    await _database.update(tableName, s.objectToMap(), where: 'id=${s.id}');
  }

  Future <List <Map <String, dynamic> > > getByID(int studentID) async {
    if (_database == null)
     await initializeDB();

    // select * from student where id=student_id
    return await _database.query(tableName, where: 'id= $studentID');
  }

  Future <List <Map <String, dynamic> > > getAllStudents() async{
    if (_database == null)
      await initializeDB();

    return await _database.query(tableName);
  }

  deleteStudent(int studentID) async {
    if (_database == null)
      await initializeDB();

    await _database.delete(tableName, where: 'id= $studentID');
  }

  Future <List <Map <String, dynamic> > > ifCSandMarkOver80 () async {
    if (_database == null)
      await initializeDB();

    return await _database.query(tableName, where: 'mark>? and major=?', whereArgs: [80,'cs']);
  }

}
