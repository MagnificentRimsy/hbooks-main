import 'package:flutter/material.dart';
import 'package:flutter_app/book.dart';
import 'package:flutter_app/login.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(
    MaterialApp(
      home: RegisterPage(),
    ),
  );
}

class RegisterPage extends StatefulWidget {
  static const String route = 'register_page';

  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  PersistentBottomSheetController _sheetController;
  bool loading=false;
  String _displayName;
  String _email;
  String _password;
  bool _loading = false;
  bool _autoValidate = false;
  String errorMsg = "";
  


  @override
  void initState() {
    super.initState();
  }

    //this is the code I want to use but I am having difficulty in applying it because someof the codes are deprecated this function below

    
    //   void _validateRegisterInput() async {
    //   final FormState form = _formKey.currentState;
    //   if (_formKey.currentState.validate()) {
//         form.save();
//         _sheetController.setState(() {
//           _loading = true;
//         });
    //     try {
    //       //
            
    //         User user = await FirebaseAuth.instance
    //           createUserWithEmailAndPassword(
    //               email: _email, password: _password);

    //       UserUpdateInfo userUpdateInfo = new UserUpdateInfo();

    //       userUpdateInfo.displayName = _displayName;

    //       user.updateProfile(userUpdateInfo).then((onValue) {
    //         Navigator.of(context).pushReplacementNamed(BookPage.route);
    //         FirebaseFirestore.instance.collection('users').doc().set(
    //             {'email': _email, 'displayName': _displayName}).then((onValue) {
    //           _sheetController.setState(() {
    //             _loading = false;
    //           });
    //         });
    //       });
    //     } catch (error) {
    //       switch (error.code) {
    //         case "ERROR_EMAIL_ALREADY_IN_USE":
    //           {
    //             _sheetController.setState(() {
    //               errorMsg = "This email is already in use.";
    //               _loading = false;
    //             });
    //             showDialog(
    //                 context: context,
    //                 builder: (BuildContext context) {
    //                   return AlertDialog(
    //                     content: Container(
    //                       child: Text(errorMsg),
    //                     ),
    //                   );
    //                 });
    //           }
    //           break;
    //         case "ERROR_WEAK_PASSWORD":
//               {
//                 _sheetController.setState(() {
//                   errorMsg = "The password must be 6 characters long or more.";
//                   _loading = false;
//                 });
//                 showDialog(
//                     context: context,
//                     builder: (BuildContext context) {
//                       return AlertDialog(
//                         content: Container(
//                           child: Text(errorMsg),
//                         ),
//                       );
//                     });
//               }
    //           break;
    //         default:
    //           {
    //             _sheetController.setState(() {
    //               errorMsg = "";
    //             });
    //           }
    //       }
    //     }
    //   } else {
    //     setState(() {
    //       _autoValidate = true;
    //     });
    //   }
    // }

    String emailValidator(String value) {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern);
      if (value.isEmpty) return '*Required';
      if (!regex.hasMatch(value))
        return '*Enter a valid email';
      else
        return null;
    }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: ListView(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    // screen header
                    SizedBox(height: 20.0),
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
                        validator: (s){
                          if(s.length<4){
                            return 'Please Enter full Name';
                          }
                          else{
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Fullname',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          filled: true,
                          fillColor: Colors.grey[300],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(90.0)),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) {
                          _displayName = value;
                        },
                      ),
                    ),

                    SizedBox(height: 20.0),
                    //forms
                    Container(
                      width: 300.0,
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        validator: (s){
                          if(!s.contains('@')){
                            return 'Invalid Email';
                          }
                          else{
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'example@gmail.com',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          filled: true,
                          fillColor: Colors.grey[300],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(90.0)),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) {
                          _email = value;
                        },
                      ),
                    ),

                    SizedBox(height: 20.0),
                    //forms
                    Container(
                      width: 300.0,
                      child: TextFormField(
                        validator: (s){
                          if(s.length<8){
                            return 'Password must be atleast 8 digits';
                          }
                          else{
                            return null;
                          }
                        },
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'password',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          filled: true,
                          fillColor: Colors.grey[300],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(90.0)),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) {
                          _password = value;
                        },
                      ),
                    ),

                    SizedBox(height: 20.0),
                    //forms
                    Container(
                      width: 300.0,
                      child: TextFormField(
                        // controller: TextConfirmPassword,
                        obscureText: true,
                        validator: (s){
                          if(s!=_password){
                            return "Passwords don't match";
                          }
                          else{
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'confirm password',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          filled: true,
                          fillColor: Colors.grey[300],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(90.0)),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      padding: EdgeInsets.fromLTRB(120, 20, 120, 20),
                      color: Hexcolor("#043e2a"),
                      child: loading
                              ? CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Colors.green),
                                )
                              :
                      Text(
                        'Register',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () async {
                        if(_formKey.currentState.validate()){
                          _formKey.currentState.save();
                          setState(() {
                            loading=true;
                          });
                          try {
                            final _auth = FirebaseAuth.instance;
                            await _auth.createUserWithEmailAndPassword(email: _email, password: _password).then((value){
                              if(value!=null){
                                FirebaseFirestore.instance.collection('users').doc(value.user.uid).set({
                                  'fullName':_displayName
                                }).then((value){
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BookPage(),
                                    ),
                                  );
                                });
                              }
                            });
                          } catch (e) {
                              setState(() {
                                loading=false;
                              });
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Container(
                                        child: Text(e.message),
                                      ),
                                    );
                                  });
                          }
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
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
                        child: Text(
                          'Or Login to Continue',
                          style: TextStyle(
                            color: Hexcolor("#7BB062"),
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      margin: EdgeInsets.only(bottom: 40.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
