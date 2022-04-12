import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assessment/constant.dart';
import 'package:flutter_assessment/modules/home_screen/bloc/contact_listing_bloc.dart';
import 'package:flutter_assessment/modules/profile_screen/views/profile_screen.dart';
import 'package:flutter_assessment/repository/contact_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:flutter_assessment/services/contact_model.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Contact>> contactListFuture;
  bool favouriteSelected = false;
  String textFieldValue = '';
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    onRefresh();
  }

  Future<void> onRefresh() async {
    setState(() {
      context
          .read<ContactListingBloc>()
          .add(const ContactListingFromDatabaseTriggered());
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {},
        ),
        body: Column(
          children: [
            ContactHeader(
              contactBloc: context.read<ContactListingBloc>(),
            ),
            SearchTextField(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                child: Column(
                  children: [
                    ContactNavigationBar(),
                    Expanded(
                      child:
                          BlocBuilder<ContactListingBloc, ContactListingModel>(
                        builder: (context, state) {
                          if (state.contactListingState
                              is ContactListingLoadingFromApi) {
                            return const Center(
                              child: CircularProgressIndicator(),
                              // child: Text('Loading from API'),
                            );
                          } else if (state.contactListingState
                              is ContactListingLoadingFromDatabase) {
                            return const Center(
                              child: CircularProgressIndicator(),
                              // child: Text('Loading from database'),
                            );
                          } else if (state.contactListingState
                              is ContactListingError) {
                            return Text((state.contactListingState
                                    as ContactListingError)
                                .message);
                          } else if (state.contactListingState
                              is ContactListingLoaded) {
                            return contactListView(
                              state.contactListFromDatabase,
                            );
                          }
                          return const Text('Error state');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
    // ));
  }

  RefreshIndicator contactListView(List<Contact> items) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          Contact contact = items[index];
          // String text = textEditingController.text;
          String fullName = '${contact.firstName} ${contact.lastName}';

          if (textFieldValue.isEmpty) {
            return contactIsFavourite(contact);
          } else {
            if (fullName.toLowerCase().contains(textFieldValue.toLowerCase())) {
              return contactIsFavourite(contact);
            } else {
              return Container();
            }
          }
        },
      ),
    );
  }

  Widget contactIsFavourite(Contact contact) {
    if (favouriteSelected) {
      if (contact.favourite == 'true') {
        return contactSlidable(contact);
      } else {
        return Container();
      }
    } else {
      return contactSlidable(contact);
    }
  }

  Slidable contactSlidable(Contact contact) {
    bool favourite = false;
    if (contact.favourite.contains('true')) {
      favourite = true;
    } else {
      favourite = false;
    }
    return Slidable(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(contact.avatar),
        ),
        title: Row(
          children: [
            Text(
              contact.firstName + ' ' + contact.lastName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Container(
              child: favourite
                  ? const Icon(
                      Icons.star,
                      color: Colors.yellow,
                    )
                  : Text(''),
            )
          ],
        ),
        subtitle: Text(contact.email),
        trailing: InkWell(
          onTap: () {
            launch('mailto:' + contact.email);
          },
          child: const Icon(Icons.email),
        ),
        // trailing: Icon(Icons.rocket),
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(contact),
                ),
              ).then((value) => onRefresh());
            },
            icon: Icons.edit,
            backgroundColor: const Color(0xFFEBF8F6),
            foregroundColor: Colors.yellow,
          ),
          SlidableAction(
            onPressed: (context) {
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Delete?'),
                    content: const Text('Do you want to delete?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('No'),
                      ),
                      TextButton(
                        onPressed: () async {
                          ContactRepoInterface().deleteContact(contact.id);
                          onRefresh();
                          Navigator.pop(context);
                        },
                        child: const Text('Yes'),
                      )
                    ],
                  );
                },
              );

              print('hello');
            },
            icon: Icons.delete,
            backgroundColor: const Color(0xFFEBF8F6),
            foregroundColor: Colors.red,
          ),
        ],
      ),
    );
  }

  Row ContactNavigationBar() {
    return Row(
      children: [
        ChoiceChip(
          selected: !favouriteSelected,
          onSelected: (bool selected) {
            setState(() {
              favouriteSelected = false;
            });
          },
          label: Text('All'),
        ),
        ChoiceChip(
          selected: favouriteSelected,
          onSelected: (bool selected) {
            setState(() {
              favouriteSelected = true;
            });
          },
          label: Text('Favourite'),
        ),
      ],
    );
  }

  Container SearchTextField() {
    return Container(
      height: 80.0,
      color: Colors.grey,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Container(
          // color: h,
          child: TextField(
            // controller: textEditingController,
            onChanged: (text) {
              setState(() {
                textFieldValue = text;
              });

              print(text);
            },
            style: const TextStyle(
              fontSize: 20,
            ),
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              hintStyle: TextStyle(color: Colors.grey[800]),
              hintText: 'Search Contact',
              contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
            ),
          ),
        ),
      ),
    );
  }

  Container ContactHeader({required ContactListingBloc contactBloc}) {
    return Container(
      height: 70.0,
      color: kPrimaryColor,
      child: Padding(
        padding: const EdgeInsets.all(21.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(), //to make it spaceBetween
            const Text(
              'My Contacts',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
            InkWell(
              onTap: () {
                contactBloc.add(const ContactListingFromApiTriggered());
                onRefresh();
              },
              child: const Icon(
                Icons.refresh,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
