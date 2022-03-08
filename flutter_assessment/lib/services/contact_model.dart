import 'dart:convert';
import 'package:hive/hive.dart';

class Contact {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String avatar;
  final String favourite;

  Contact({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.avatar,
    required this.favourite,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'avatar': avatar,
      'favourite': favourite,
    };
  }

  Contact.fromMap(Map<String, dynamic> data)
      : id = int.parse(data['id']),
        email = data['email'],
        firstName = data['first_name'],
        lastName = data['last_name'],
        avatar = data['avatar'],
        favourite = data['favourite'];
}
