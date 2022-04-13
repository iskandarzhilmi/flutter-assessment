import 'package:flutter/material.dart';
import 'package:flutter_assessment/constant.dart';
import 'package:flutter_assessment/modules/edit_screen/views/edit_screen.dart';
import 'package:flutter_assessment/repository/contact_repository.dart';
import 'package:flutter_assessment/services/contact_model.dart';
import 'package:flutter_assessment/widgets/header.dart';

import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  static const String id = 'profile_screen';

  const ProfileScreen(this.contact);

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
            ProfileHeader(),
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
            Container(
              height: 100.0,
              width: 100.0,
              child: Center(
                child: Stack(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (favourite) {
                            favourite = false;
                          } else {
                            favourite = true;
                          }
                          ContactRepoInterface().toggleFavourite(contact.id);
                        });
                      },
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(contact.avatar),
                        radius: 50.0,
                      ),
                    ),
                    Positioned(
                      bottom: 5,
                      right: 5,
                      child: favourite
                          ? const Icon(
                              Icons.star,
                              color: favouriteStarColor,
                            )
                          : const Icon(
                              Icons.star_border,
                              color: favouriteStarColor,
                            ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              contact.firstName + ' ' + contact.lastName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),
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
              padding: const EdgeInsets.all(22.0),
              child: InkWell(
                onTap: () {
                  launch('mailto:' + contact.email);
                },
                child: Container(
                  height: 47.0,
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                  child: const Center(
                    child: Text(
                      'Send Email',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
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
