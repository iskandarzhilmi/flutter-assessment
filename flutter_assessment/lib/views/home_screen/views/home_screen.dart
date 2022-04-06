import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assessment/views/home_screen/bloc/contact_refresh_bloc.dart';
import 'package:flutter_assessment/views/profile_screen.dart';
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

    setState(() {
      contactListFuture = DatabaseHelper().getContactListFuture();
    });
  }

  // Future<List<Contact>> getContactListFuture() async {
  //   return await DatabaseHelper().getContactListFuture();
  // }

  Future<void> onRefresh() async {
    setState(() {
      contactListFuture = DatabaseHelper().getContactListFuture();
    });
  }

  void fetchContact() async {
    DatabaseHelper().deleteAllContact();

    Response response =
        await get(Uri.parse('https://reqres.in/api/users?page=1'));
    Map<String, dynamic> data;

    for (int i = 0; i < 6; i++) {
      data = jsonDecode(response.body)['data'][i];
      Contact contact = Contact.fromMap(data);
      DatabaseHelper().insertContact(contact);
    }
    onRefresh();
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
              contactBloc: context.read<ContactBloc>(),
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
                      child: BlocBuilder<ContactBloc, ContactRefreshModel>(
                        builder: (context, state) {
                          if (state.contactState is ContactRefreshLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (state.contactState
                              is ContactRefreshError) {
                            return Text(
                                (state.contactState as ContactRefreshError)
                                    .message);
                          } else if (state.contactState
                              is ContactRefreshLoaded) {
                            //TODO: Think what to do, whether to directly call deleteAllContact() or use cubit/bloc.

                            //I think what I did here is calling directly from the api instead of calling from the database.
                            //I think about adding into the database using another bloc. (insertContactList())

                            return contactListView(state.contactList);
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
      // ignore: prefer_const_constructors
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(contact.avatar),
        ),
        title: Row(
          children: [
            Text(contact.firstName + ' ' + contact.lastName),
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
          child: Icon(Icons.email),
        ),
        // trailing: Icon(Icons.rocket),
      ),
      endActionPane: ActionPane(
        motion: ScrollMotion(),
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
            backgroundColor: Color(0xFFEBF8F6),
            foregroundColor: Colors.yellow,
          ),
          SlidableAction(
            onPressed: (context) {
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Delete?'),
                    content: Text('Do you want to delete?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('No'),
                      ),
                      TextButton(
                        onPressed: () async {
                          DatabaseHelper().deleteContact(contact.id);
                          onRefresh();
                          Navigator.pop(context);
                        },
                        child: Text('Yes'),
                      )
                    ],
                  );
                },
              );

              print('hello');
            },
            icon: Icons.delete,
            backgroundColor: Color(0xFFEBF8F6),
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
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(80.0),
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Container ContactHeader({required ContactBloc contactBloc}) {
    return Container(
      height: 70.0,
      color: const Color(0xff32baa5),
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
              // fetchContact();
              contactBloc.add(const ContactRefreshPressed());
              onRefresh();
            },
            child: Icon(
              Icons.refresh,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

// BlocBuilder<ContactBloc, ContactStateModel>
