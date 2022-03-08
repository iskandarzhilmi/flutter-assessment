import 'package:flutter/material.dart';
import 'package:flutter_assessment/services/database.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:flutter_assessment/services/contact_model.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Contact>> _contact;

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

    displayDatabase();
  }

  Future<List<Contact>> getContactFutureList() async {
    return await DatabaseHandler().getContactFutureList();
  }

  Future<void> _onRefresh() async {
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
      _onRefresh();
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
                    onRefresh: _onRefresh,
                    child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (BuildContext context, int index) {
                          return contactSlidable(
                            id: items[index].id.toString(),
                            avatarLink: items[index].avatar,
                            firstName: items[index].firstName,
                            lastName: items[index].lastName,
                            email: items[index].email,
                          );
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

  Slidable contactSlidable(
      {required String id,
      required String avatarLink,
      required String firstName,
      required String lastName,
      required String email}) {
    return Slidable(
      // ignore: prefer_const_constructors
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(avatarLink),
        ),
        title: Text(firstName + ' ' + lastName),
        subtitle: Text(email),
        trailing: Icon(Icons.email),
        // trailing: Icon(Icons.rocket),
      ),
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              DatabaseHandler().toggleFavourite(int.parse(id));
            },
            icon: Icons.edit,
            backgroundColor: Color(0xFFEBF8F6),
            foregroundColor: Colors.yellow,
          ),
          SlidableAction(
            onPressed: (context) {
              DatabaseHandler().deleteContact(int.parse(id));
              _onRefresh();
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
        Chip(label: Text('All')),
        Chip(label: Text('Favourite')),
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
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
        children: [
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
