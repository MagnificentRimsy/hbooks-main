import 'package:flutter/material.dart';
import 'package:flutter_app/book.dart';
import 'package:flutter_app/login.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'AddBook.dart';

//void main() => runApp(MyApp());

class SideMenu extends StatefulWidget {
  SideMenu({Key key}) : super(key: key);

  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              children: [
                Image.asset(
                  "assets/images/logo_h.jpg",
                  height: 100.0,
                  width: 150.0,
                ),
                Text(
                  'Policy Documents from the Department of Food and Drug Services',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: Hexcolor("#043e2a"),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              // Update the state of the app.
              // ...
              Navigator.pushNamed(context, BookPage.route);
            },
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Add Book'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddBook(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              _auth.signOut();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
