import 'package:flutter/material.dart';
import 'package:flutter_assessment/constant.dart';
import 'package:flutter_assessment/views/home_screen/bloc/contact_listing_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../home_screen/views/home_screen.dart';
import 'package:flutter_assessment/services/contact_model.dart';
import '../../../helpers/database_helper.dart';

class EditScreen extends StatefulWidget {
  EditScreen(this.contact, {Key? key}) : super(key: key);

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
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                height: 70.0,
                color: kPrimaryColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back),
                    ),
                    const Text('Profile'),
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
                          context.read<ContactListingBloc>().add(
                                ContactListingEditSubmitted(
                                  Contact(
                                    id: contact.id,
                                    email: email,
                                    firstName: firstName,
                                    lastName: lastName,
                                    avatar: contact.avatar,
                                    favourite: contact.favourite,
                                  ),
                                ),
                              );

                          Navigator.of(context)
                              .popUntil(ModalRoute.withName(HomeScreen.id));
                        },
                        child: Container(
                          height: 60.0,
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: const Center(
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
