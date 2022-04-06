import 'dart:convert';

import 'package:flutter_assessment/services/contact_model.dart';
import 'package:flutter_assessment/services/database.dart';
import 'package:http/http.dart';

abstract class ContactRepoInterface {
  factory ContactRepoInterface() => ContactRepo();

  Future<Contact> getSingleContact(int index);
  Future<List<Contact>> getContactListFromApi();
}

class ContactRepo implements ContactRepoInterface {
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
    //Todo: Add

    //Return contact list
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
}
