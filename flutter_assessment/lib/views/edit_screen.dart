import 'package:flutter/material.dart';
import 'home_screen/home_screen.dart';
import 'package:flutter_assessment/services/contact_model.dart';
import 'package:flutter_assessment/services/database.dart';

class EditScreen extends StatefulWidget {
  EditScreen(this.contact);

  Contact contact;

  @override
  _EditScreenState createState() => _EditScreenState(contact);
}

class _EditScreenState extends State<EditScreen> {
  Contact contact;
  _EditScreenState(this.contact);

  late String firstName;
  late String lastName;
  late String email;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firstName = contact.firstName;
    lastName = contact.lastName;
    email = contact.email;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
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
                      child: Icon(Icons.arrow_back),
                    ),
                    Text('Profile'),
                    Container(),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20.0),
                      CircleAvatar(
                        backgroundImage: NetworkImage(contact.avatar),
                      ),
                      const SizedBox(height: 20.0),
                      ProfileTextField(
                        labelText: 'First Name',
                        initialValue: contact.firstName,
                        onChanged: (value) {
                          firstName = value;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      ProfileTextField(
                        labelText: 'Last Name',
                        initialValue: contact.lastName,
                        onChanged: (value) {
                          lastName = value;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      ProfileTextField(
                        labelText: 'First Name',
                        initialValue: contact.email,
                        onChanged: (value) {
                          email = value;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      InkWell(
                        onTap: () {
                          DatabaseHandler().editContact(
                              contact.id, firstName, lastName, email);

                          Navigator.of(context)
                              .popUntil(ModalRoute.withName(HomeScreen.id));
                        },
                        child: Container(
                          height: 60.0,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Center(
                            child: Text('Done'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileTextField extends StatelessWidget {
  ProfileTextField(
      {required this.labelText,
      required this.onChanged,
      required this.initialValue});

  final Function(String) onChanged;
  final String labelText;
  final String initialValue;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(text: initialValue),
      onChanged: onChanged,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: labelText,
      ),
    );
  }
}
