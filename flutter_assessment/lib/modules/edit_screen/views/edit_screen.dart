import 'package:flutter/material.dart';
import 'package:flutter_assessment/constant.dart';
import 'package:flutter_assessment/modules/home_screen/bloc/contact_listing_bloc.dart';
import 'package:flutter_assessment/widgets/header.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../home_screen/views/home_screen.dart';
import 'package:flutter_assessment/services/contact_model.dart';

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
              ProfileHeader(),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20.0),
                      CircleAvatar(
                        backgroundColor: kPrimaryColor,
                        radius: 62.5,
                        child: CircleAvatar(
                          radius: 57.5,
                          backgroundImage: NetworkImage(contact.avatar),
                        ),
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
                        labelText: 'Email',
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
                            child: Text(
                              'Done',
                              style: TextStyle(
                                color: kTextColor,
                              ),
                            ),
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
