import 'package:flutter/material.dart';
import 'package:flutter_assessment/views/edit_screen.dart';
import 'package:flutter_assessment/services/contact_model.dart';
import '../helpers/database_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  static const String id = 'profile_screen';

  ProfileScreen(this.contact);

  final Contact contact;

  @override
  _ProfileScreenState createState() => _ProfileScreenState(contact);
}

class _ProfileScreenState extends State<ProfileScreen> {
  Contact contact;
  _ProfileScreenState(this.contact);
  bool favourite = false;

  @override
  void initState() {
    super.initState();

    if (contact.favourite.contains('true')) {
      favourite = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              height: 70.0,
              color: Colors.green,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back),
                  ),
                  const Text('Profile'),
                  Container(),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditScreen(contact),
                      ),
                    );
                  },
                  child: const Text('Edit'),
                ),
              ],
            ),
            InkWell(
              onTap: () {
                setState(() {
                  if (favourite) {
                    favourite = false;
                  } else {
                    favourite = true;
                  }

                  DatabaseHelper().toggleFavourite(contact.id);
                });
              },
              child: CircleAvatar(
                backgroundImage: NetworkImage(contact.avatar),
                radius: 50.0,
                child: favourite
                    ? const Icon(Icons.star)
                    : const Icon(Icons.star_border),
              ),
            ),
            Text(contact.firstName + ' ' + contact.lastName),
            Container(
              width: double.infinity,
              color: Colors.grey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Icon(Icons.email),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Text(contact.email),
                  const SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: InkWell(
                onTap: () {
                  launch('mailto:' + contact.email);
                },
                child: Container(
                  height: 60.0,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: const Center(
                    child: Text('Send Email'),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
