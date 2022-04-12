import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../services/contact_model.dart';

//TODO: combine database helper with contact repo
class DatabaseHelper {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'contact.db'),
      onCreate: (database, version) async {
        await database.execute(
          'CREATE TABLE contact(id INTEGER PRIMARY KEY, firstName TEXT, lastName TEXT, email TEXT, avatar TEXT, favourite TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertContact(Contact contact) async {
    final db = await initializeDB();
    await db.insert(
      'contact',
      contact.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertContactList(List<Contact> contactList) async {
    final db = await initializeDB();

    for (Contact contact in contactList) {
      await db.insert(
        'contact',
        contact.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<List<Contact>> getContactList() async {
    final db = await initializeDB();
    final List<Map<String, dynamic>> queryResult = await db.query('contact');
    return queryResult
        .map(
          (data) => Contact(
            id: data['id'],
            email: data['email'],
            firstName: data['firstName'],
            lastName: data['lastName'],
            avatar: data['avatar'],
            favourite: data['favourite'],
          ),
        )
        .toList();
  }

  Future<void> deleteContact(int id) async {
    final db = await initializeDB();
    await db.delete(
      'contact',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> toggleFavourite(int id) async {
    final db = await initializeDB();
    String favouriteString = 'true';

    var futureMapList = db.query(
      'contact',
      columns: ["favourite"],
      where: 'id = ?',
      whereArgs: [id],
    );
    futureMapList.then((value) async {
      print(value);
      favouriteString = value[0]['favourite'].toString();
      print('Before: ' + favouriteString);

      if (favouriteString.contains('false')) {
        print('its false');
        await db.execute(
            'update contact set favourite="true" where id=' + id.toString());
      } else {
        print('its true');
        await db.execute(
            'update contact set favourite="false" where id=' + id.toString());
      }
    });
  }

  Future<void> editContact(
      int id, String firstName, String lastName, String email) async {
    final db = await initializeDB();
    await db.execute(
        'update contact set firstName="$firstName", lastName="$lastName", email="$email" where id=' +
            id.toString());
  }

  Future<void> deleteAllContact() async {
    final db = await initializeDB();
    await db.execute('delete from contact');
  }
}
