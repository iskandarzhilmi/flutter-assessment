import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'contact_model.dart';

class DatabaseHandler {
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

  Future<List<Contact>> getContactFutureList() async {
    final db = await initializeDB();
    final List<Map<String, dynamic>> queryResult = await db.query('contact');
    print(queryResult);
    // return queryResult.map((e) => Contact.fromMap(e)).toList();
    return queryResult
        .map((data) => Contact(
              id: data['id'],
              email: data['email'],
              firstName: data['firstName'],
              lastName: data['lastName'],
              avatar: data['avatar'],
              favourite: data['favourite'],
            ))
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

    var query = db.query(
      'contact',
      columns: ["favourite"],
      where: 'id = ?',
      whereArgs: [id],
    );
    query.then((value) {
      favouriteString = value[0]['favourite'].toString();
      // print('Before: ' + favouriteString);
    });
    if (favouriteString.contains('false')) {
      print('hello');
      // await db.update(
      //   'contact',
      //   {'favourite': 'true'},
      //   where: 'id = ?',
      //   whereArgs: [id],
      // );
      await db.execute(
          'update contact set favourite="false" where id=' + id.toString());
    } else {
      print('not hello');
      // await db.update(
      //   'contact',
      //   {'favourite': 'true'},
      //   where: 'id = ?',
      //   whereArgs: [id],
      // );
      await db.execute(
          'update contact set favourite="true" where id=' + id.toString());
    }
    // print('After: ' + favouriteString);
  }

  Future<void> deleteAllContact() async {
    final db = await initializeDB();
    await db.execute('delete from contact');
  }
}
