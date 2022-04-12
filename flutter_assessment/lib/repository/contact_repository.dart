import 'dart:convert';

import 'package:flutter_assessment/services/contact_model.dart';
import 'package:sqflite/sqflite.dart';
import '../helpers/database_helper.dart';
import 'package:http/http.dart';
import 'package:path/path.dart';

abstract class ContactRepoInterface {
  factory ContactRepoInterface() => ContactRepo();
  Future<Database> initializeDB();
  Future<Contact> getSingleContact(int index);
  Future<List<Contact>> getContactListFromApi();
  Future<void> insertContactList(List<Contact> contactList);
  Future<List<Contact>> getContactListFromDatabase();
  Future<void> editContact(
      int id, String firstName, String lastName, String email);
  Future<void> deleteContact(int id);
  Future<void> toggleFavourite(int id);
  Future<void> deleteAllContact();
}

class ContactRepo implements ContactRepoInterface {
  @override
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

  @override
  Future<Contact> getSingleContact(int index) async {
    Response response =
        await get(Uri.parse('https://reqres.in/api/users?page=1'));
    Map<String, dynamic> data;

    data = jsonDecode(response.body)['data'][index];
    var contact = Contact.fromMap(data);

    return contact;
  }

  @override
  Future<List<Contact>> getContactListFromApi() async {
    List<Contact> contactList = [];
    Response response =
        await get(Uri.parse('https://reqres.in/api/users?page=1'));
    Map<String, dynamic> data;
    for (int i = 0; i < 6; i++) {
      data = jsonDecode(response.body)['data'][i];
      Contact contact = Contact.fromMap(data);
      contactList.add(contact);
    }
    return contactList;
  }

  @override
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

  @override
  Future<List<Contact>> getContactListFromDatabase() async {
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

  @override
  Future<void> editContact(
      int id, String firstName, String lastName, String email) async {
    final db = await initializeDB();
    await db.execute(
        'update contact set firstName="$firstName", lastName="$lastName", email="$email" where id=' +
            id.toString());
  }

  @override
  Future<void> deleteContact(int id) async {
    final db = await initializeDB();
    await db.delete(
      'contact',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
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

  @override
  Future<void> deleteAllContact() async {
    final db = await initializeDB();
    await db.execute('delete from contact');
  }
}
