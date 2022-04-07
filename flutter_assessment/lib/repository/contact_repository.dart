import 'dart:convert';

import 'package:flutter_assessment/services/contact_model.dart';
import '../helpers/database_helper.dart';
import 'package:http/http.dart';

abstract class ContactRefreshRepoInterface {
  factory ContactRefreshRepoInterface() => ContactRepo();

  Future<Contact> getSingleContact(int index);
  Future<List<Contact>> getContactListFromApi();
  Future<void> insertContactList(List<Contact> contactList);
  Future<List<Contact>> getContactListFromDatabase();
}

class ContactRepo implements ContactRefreshRepoInterface {
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
    //TODO: Try using a safer way instead of using 6 as max.
    for (int i = 0; i < 6; i++) {
      data = jsonDecode(response.body)['data'][i];
      Contact contact = Contact.fromMap(data);
      contactList.add(contact);
    }
    return contactList;
  }

  @override
  Future<void> insertContactList(List<Contact> contactList) async {
    await DatabaseHelper().insertContactList(contactList);
  }

  @override
  Future<List<Contact>> getContactListFromDatabase() async{
    return await DatabaseHelper().getContactList();
  }
}
