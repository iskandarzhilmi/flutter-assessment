import 'package:flutter/material.dart';
import 'package:flutter_assessment/screens/profile_screen.dart';
import 'package:flutter_assessment/services/database.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:flutter_assessment/services/contact_model.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Contact>> _contact;
  bool favouriteSelected = false;

  String textFieldValue = '';

  void getUserData() async {
    // var response = await get(Uri.parse('https://reqres.in/api/users?page=1'));
    // if (response.statusCode == 200) {
    //   print('hello: ' + jsonDecode(response.body)['data'][0].toString());
    // } else {
    //   print(response.statusCode);
    // }
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      _contact = getContactFutureList();
    });

    getUserData();
  }

  Future<List<Contact>> getContactFutureList() async {
    return await DatabaseHandler().getContactFutureList();
  }

  Future<void> onRefresh() async {
    setState(() {
      _contact = getContactFutureList();
    });
  }

  void fetchContact() async {
    DatabaseHandler().deleteAllContact();

    var response = await get(Uri.parse('https://reqres.in/api/users?page=1'));
    var data;

    for (int i = 0; i < 6; i++) {
      data = jsonDecode(response.body)['data'][i];
      var contact = Contact(
        id: data['id'],
        email: data['email'],
        firstName: data['first_name'],
        lastName: data['last_name'],
        avatar: data['avatar'],
        favourite: 'false',
      );
      DatabaseHandler().insertContact(contact);
      onRefresh();
      // DatabaseHandler().contactList();
    }
  }

  void displayDatabase() async {
    // print(await DatabaseHandler().contactList());
    // DatabaseHandler().contactList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
        onPressed: () {},
      ),
      body: Column(
        children: [
          ContactHeader(),
          SearchTextField(),
          ContactNavigationBar(),
          Expanded(
            child: FutureBuilder<List<Contact>>(
              future: _contact,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Contact>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  print(snapshot);
                  return Text('Error: ${snapshot.error}');
                } else {
                  final items = snapshot.data ?? <Contact>[];
                  return RefreshIndicator(
                    onRefresh: onRefresh,
                    child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (BuildContext context, int index) {
                          // if (textFieldValue.isEmpty) {
                          if (favouriteSelected) {
                            if (items[index].favourite == 'true') {
                              return contactSlidable(items[index]);
                            } else {
                              return Container();
                            }
                          } else {
                            return contactSlidable(items[index]);
                          }
                          // }
                        }),
                  );
                }
              },
            ),
          ),
        ],
      ),
    ));
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
                  ? Icon(
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
                          DatabaseHandler().deleteContact(contact.id);
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
          child: TextField(
            controller: TextEditingController(
              text: textFieldValue,
            ),
          ),
        ),
      ),
    );
  }

  Container ContactHeader() {
    return Container(
      height: 70.0,
      color: Colors.green,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(),
          Text('My Contacts'),
          InkWell(
            onTap: () {
              fetchContact();
            },
            child: Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}
