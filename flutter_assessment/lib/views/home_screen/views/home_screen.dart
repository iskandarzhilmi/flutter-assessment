import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assessment/constant.dart';
import 'package:flutter_assessment/views/home_screen/bloc/contact_refresh_bloc.dart';
import 'package:flutter_assessment/views/profile_screen/views/profile_screen.dart';
import '../../../helpers/database_helper.dart';
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

  @override
  void initState() {
    super.initState();
    onRefresh();
  }

  Future<void> onRefresh() async {
    setState(() {
      context
          .read<ContactRefreshBloc>()
          .add(const ContactRefreshFromDatabaseTriggered());
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
              contactBloc: context.read<ContactRefreshBloc>(),
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
                          BlocBuilder<ContactRefreshBloc, ContactRefreshModel>(
                        builder: (context, state) {
                          if (state.contactRefreshState
                              is ContactRefreshLoadingFromApi) {
                            return const Center(
                              child: CircularProgressIndicator(),
                              // child: Text('Loading from API'),
                            );
                          } else if (state.contactRefreshState
                              is ContactRefreshLoadingFromDatabase) {
                            return const Center(
                              child: CircularProgressIndicator(),
                              // child: Text('Loading from database'),
                            );
                          } else if (state.contactRefreshState
                              is ContactRefreshError) {
                            return Text((state.contactRefreshState
                                    as ContactRefreshError)
                                .message);
                          } else if (state.contactRefreshState
                              is ContactRefreshLoaded) {
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
          if (favouriteSelected) {
            if (items[index].favourite == 'true') {
              return contactSlidable(items[index]);
            } else {
              return Container();
            }
          } else {
            return contactSlidable(items[index]);
          }
        },
      ),
    );
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
                          DatabaseHelper().deleteContact(contact.id);
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

  Container ContactHeader({required ContactRefreshBloc contactBloc}) {
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
                contactBloc.add(const ContactRefreshFromApiTriggered());
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
