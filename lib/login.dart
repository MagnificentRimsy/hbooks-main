import 'package:flutter/material.dart';
import 'package:flutter_app/book.dart';
import 'package:flutter_app/register.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'models/Globals.dart';

void main() {
  runApp(
    MaterialApp(
      home: LoginPage(),
    ),
  );
}

class LoginPage extends StatefulWidget {
  static const String route = 'login_screen';
  
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool showSpinner = false;
  String email;
  String password;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ModalProgressHUD(
          color: Colors.green,
          inAsyncCall: showSpinner,
          child: Center(
            child: ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    // screen header
                    SizedBox(height: 40.0),
                    Hero(
                      tag: 'logo',
                      child: Image.asset(
                        "assets/images/logo_h.jpg",
                        height: 120.0,
                        width: 120.0,
                      ),
                    ),
                    SizedBox(height: 40.0),
                    //forms
                    Container(
                      width: 300.0,
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'example@gmail.com',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          filled: true,
                          fillColor: Colors.grey[300],
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(90.0)),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) {
                          email = value;
                        },
                      ),
                    ),

                    SizedBox(height: 20.0),
                    //forms
                    Container(
                      width: 300.0,
                      child: TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'password',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          filled: true,
                          fillColor: Colors.grey[300],
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(90.0)),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) {
                          password = value;
                        },
                      ),
                    ),

                    //forms

                    SizedBox(height: 40),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      padding: EdgeInsets.fromLTRB(120, 20, 120, 20),
                      color: Hexcolor("#043e2a"),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () async {
                        setState(() {
                          showSpinner = true;
                        });
                        try {
                          final user = await _auth.signInWithEmailAndPassword(
                              email: email, password: password);

                          if (user != null) {
                            Globals.currentuser=user.user;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookPage(),
                              ),
                            );
                          }
                          setState(() {
                            showSpinner = false;
                          });
                        } catch (e) {
                          setState(() {
                            showSpinner = false;
                          });
                          print(e);
                        }
                      },
                    ),
                    SizedBox(height: 20),
                    Container(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterPage(),
                            ),
                          );
                        },
                        child: Text(
                          'Or Register to Continue',
                          style: TextStyle(
                            color: Hexcolor("#7BB062"),
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoadingCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: CircularProgressIndicator(),
        alignment: Alignment(0.0, 0.0),
      ),
    );
  }
}
