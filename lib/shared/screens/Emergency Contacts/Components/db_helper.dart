
import 'package:path/path.dart' show join;
import 'package:smarthelmet/shared/screens/Emergency%20Contacts/Components/personal_emergency_contacts_model.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;

class DBHelper {
  static Database? _db;
  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDatabase();
    return _db!;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'EmergencyContacts2.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE contacts (id TEXT , name TEXT, contactNo TEXT, PRIMARY KEY(id,contactNo))');
  }

  Future<PersonalEmergency> add(PersonalEmergency contacts) async {
    var dbClient = await db;
    var name = contacts.name;
    var contactNo = contacts.contactNo;
    var id = contacts.id;
    dbClient.rawInsert(
        "INSERT into contacts(id,name,contactNo)"
        "VALUES(?, ?,?)",
        [id, name, contactNo]);
    return contacts;
  }

  Future<List<PersonalEmergency>> getContacts(String uid) async {
    var dbClient = await db;
    print(uid);
    List<Map> maps =
        await dbClient.rawQuery("SELECT * FROM contacts WHERE id='${uid}'  ");
    //,columns: ['id', 'name', 'contactNo']);
    List<PersonalEmergency> contacts = [];
    if (maps.isNotEmpty) {
      for (int i = 0; i < maps.length; i++) {
        contacts.add(PersonalEmergency.fromMap(maps[i]));
      }
    }

    return contacts;
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(
      'contacts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> update(PersonalEmergency contacts) async {
    var dbClient = await db;
    return await dbClient.update(
      'contacts',
      contacts.toMap(),
      where: 'id = ?',
      whereArgs: [contacts.id],
    );
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
